class PerconaXtrabackup < Formula
  desc "Open source hot backup tool for InnoDB and XtraDB databases"
  homepage "https://www.percona.com/software/mysql-database/percona-xtrabackup"
  url "https://downloads.percona.com/downloads/Percona-XtraBackup-9.7/Percona-XtraBackup-9.7.2-2/source/tarball/percona-xtrabackup-9.7.2-2.tar.gz"
  sha256 "b7d2e4fa7407a000d26870022ac382ae5187523dcecd83037f35d7374be58064"
  license "GPL-2.0-only"

  livecheck do
    url "https://www.percona.com/wp-admin/admin-ajax.php", post_form: {
      action:     "percona_downloads",
      product_id: "Percona-XtraBackup-#{version.major_minor}",
    }
    regex(/^Percona-XtraBackup-v?(\d+(?:[.-]\d+)+)$/i)
    strategy :json do |json, regex|
      json.dig("data", "versions")&.filter_map do |version|
        version[regex, 1]
      end
    end
  end

  bottle do
    sha256 arm64_golden_gate: "f9dc496432fbff606528af3acd5d1120e56c5640534d8a127cac863d19b6153a"
    sha256 arm64_tahoe:       "d92a1a4a4df80b9add4eeace8b6b24d42393fe19b098af5077fbb9973bb4a5b5"
    sha256 arm64_sequoia:     "e1856d613879a8bb08cb17bdcb5142b167ed4b6512ac06c4d3ed2bdf8fbb13b4"
    sha256 arm64_linux:       "f0f2e1151b1f92d80bc4e4fa839e231cc83d9b5ec37edd7310dcfafa05cfae9d"
    sha256 x86_64_linux:      "fd8010b6991d96a8c121cd62c145a1d660ab2488eb19cbe73f46f0289cd1a4db"
  end

  depends_on "bison" => :build # needs bison >= 3.0.4
  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "sphinx-doc" => :build
  depends_on "percona-server" => :test
  depends_on "icu4c@79"
  depends_on "libev"
  depends_on "libgcrypt"
  depends_on "lz4"
  depends_on "openssl@4"
  depends_on "protobuf"
  depends_on "zlib-ng-compat" # Zlib 1.2.13+
  depends_on "zstd"

  uses_from_macos "cyrus-sasl" => :build
  uses_from_macos "libedit" => :build
  uses_from_macos "curl"

  on_linux do
    depends_on "patchelf" => :build
    depends_on "libaio"
    depends_on "libtirpc"
    depends_on "procps"
  end

  # Apply Debian's MySQL 9.7 patch to fix build with OpenSSL 4
  patch do
    url "https://salsa.debian.org/mariadb-team/mysql/-/raw/ac6576612c0afddccebf939fccedacc3b97db567/debian/patches/support-openssl4.patch"
    sha256 "fd0eb6d47ce5aaef43e58240d9884d04b1ee30fd3c57395b405d9400ae136a02"
    type :unofficial
  end

  # Patch out check for Homebrew `boost`.
  # This should not be necessary when building inside `brew`.
  # https://github.com/Homebrew/homebrew-test-bot/pull/820
  patch do
    file "Patches/mysql/remove-boost-check.diff"
    type :unofficial
  end

  allow_network_access! :test

  def install
    # Remove bundled libraries other than explicitly allowed below.
    # `boost` and `rapidjson` must use bundled copy due to patches.
    # `lz4` is still needed due to xxhash.c used by xbstream
    keep = %w[boost libbacktrace libcno libkmip lz4 rapidjson unordered_dense xxhash]
    (buildpath/"extra").each_child { |dir| rm_r(dir) unless keep.include?(dir.basename.to_s) }

    # Disable ABI checking
    inreplace "cmake/abi_check.cmake", "RUN_ABI_CHECK 1", "RUN_ABI_CHECK 0" if OS.linux?

    # FIXME: `common.h` stubs `posix_fadvise` as a macro on macOS, which breaks the `::` qualifier
    inreplace "storage/innobase/xtrabackup/src/xb_io_probe.h", "::posix_fadvise(", "posix_fadvise(" if OS.mac?

    # Avoid installing manpages that conflict with MySQL / Percona Server
    inreplace "CMakeLists.txt", /^\s*ADD_SUBDIRECTORY\(man\)$/, ""

    icu4c = deps.map(&:to_formula).find { |f| f.name.match?(/^icu4c@\d+$/) }
    # -DWITH_FIDO=system isn't set as feature isn't enabled and bundled copy was removed.
    # Formula paths are set to avoid HOMEBREW_HOME logic in CMake scripts
    cmake_args = %W[
      -DBUILD_CONFIG=xtrabackup_release
      -DCOMPILATION_COMMENT=Homebrew
      -DINSTALL_PLUGINDIR=lib/percona-xtrabackup/plugin
      -DINSTALL_MANDIR=#{man}
      -DWITH_MAN_PAGES=ON
      -DINSTALL_MYSQLTESTDIR=
      -DBISON_EXECUTABLE=#{formula_opt_bin("bison")}/bison
      -DOPENSSL_ROOT_DIR=#{formula_opt_prefix("openssl@4")}
      -DWITH_ICU=#{icu4c.opt_prefix}
      -DWITH_SYSTEM_LIBS=ON
      -DWITH_EDITLINE=system
      -DWITH_LZ4=system
      -DWITH_PROTOBUF=system
      -DWITH_SSL=system
      -DWITH_ZLIB=system
      -DWITH_ZSTD=system
    ]
    # Reduce overlinking on macOS
    cmake_args += %w[EXE MODULE].map { |type| "-DCMAKE_#{type}_LINKER_FLAGS=-Wl,-dead_strip_dylibs" } if OS.mac?

    system "cmake", "-S", ".", "-B", "build", *cmake_args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    # remove conflicting library that is already installed by mysql
    (lib/"libmysqlservices.a").unlink
    # remove conflicting libraries/headers that are installed by percona-server
    (lib/"libkmip.a").unlink
    (lib/"libkmipclient.a").unlink
    (lib/"libkmipcore.a").unlink
    (lib/"libkmippp.a").unlink
    (include/"kmip.h").unlink
    (include/"kmippp.h").unlink
  end

  test do
    mysql_bin = formula_opt_bin("percona-server")
    common_args = %W[--no-defaults --port=#{free_port} --socket=#{testpath}/mysql.sock]
    client_args = %w[--user=root --password=]
    server_args = %W[--datadir=#{testpath}/mysql --tmpdir=#{testpath}/tmp]
    mysqld_args = common_args + server_args + %W[--mysqlx=OFF --user=#{ENV["USER"]}]
    mysqladmin_args = common_args + client_args
    xtrabackup_args = common_args + client_args + server_args + %W[--target-dir=#{testpath}/backup --backup]

    (testpath/"backup").mkpath
    (testpath/"mysql").mkpath
    (testpath/"tmp").mkpath

    assert_match version.to_s, shell_output("#{bin}/xtrabackup --version 2>&1")

    output = shell_output("#{bin}/xtrabackup #{xtrabackup_args.join(" ")} 2>&1", 1)
    assert_match "Failed to connect to MySQL server", output

    system mysql_bin/"mysqld", *mysqld_args, "--initialize-insecure"
    pid = spawn(mysql_bin/"mysqld", *mysqld_args)
    begin
      sleep 5
      output = shell_output("#{bin}/xtrabackup #{xtrabackup_args.join(" ")} 2>&1")
      refute_match "[ERROR]", output
      assert_match "[Xtrabackup] completed OK!", output
      assert_path_exists testpath/"backup/xtrabackup_info"
    ensure
      system mysql_bin/"mysqladmin", *mysqladmin_args, "shutdown"
      Process.kill "TERM", pid
    end
  end
end
