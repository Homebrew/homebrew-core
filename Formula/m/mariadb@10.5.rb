class MariadbAT105 < Formula
  desc "Drop-in replacement for MySQL"
  homepage "https://mariadb.org/"
  url "https://archive.mariadb.org/mariadb-10.5.28/source/mariadb-10.5.28.tar.gz"
  sha256 "0b5070208da0116640f20bd085f1136527f998cc23268715bcbf352e7b7f3cc1"
  license "GPL-2.0-only"

  livecheck do
    url "https://downloads.mariadb.org/rest-api/mariadb/all-releases/?olderReleases=false"
    strategy :json do |json|
      json["releases"]&.map do |release|
        next unless release["release_number"]&.start_with?(version.major_minor)
        next if release["status"] != "stable"

        release["release_number"]
      end
    end
  end

  bottle do
    sha256 arm64_sequoia: "a96a6208d4bfe250d5b74416e14a31086e2d538a512b1f59698dcb50e19348bb"
    sha256 arm64_sonoma:  "9aaa6d34bb857450b03972b3f7f879a7d46ce93235a3fca00fdbdd2580c8b919"
    sha256 arm64_ventura: "ef61353ca947499a30b62433da89edd9d6b791ebe2d1ec8f9091fcedf06baf02"
    sha256 sonoma:        "0ebc972d9d5ca4c66a37776bd2e80d06293da8b41cf2239f31371b84007fda0f"
    sha256 ventura:       "c4bf53cb65f70e4b46d129ace5df49753fc7c9bd7b4c0d8e80965644c562e67b"
    sha256 arm64_linux:   "f0fba839c8726cbe4378213bffc9b55d04ac9a96f4e07ec7441a417e70c317e8"
    sha256 x86_64_linux:  "4a6c0cb6fde2bbbf0302a77fa6d9f8c5bbbeb062c03a58b3ff4276a01e97261b"
  end

  keg_only :versioned_formula

  # See: https://mariadb.com/kb/en/changes-improvements-in-mariadb-105/
  # End-of-life on 2025-06-24: https://mariadb.org/about/#maintenance-policy
  deprecate! date: "2025-06-24", because: :unsupported

  depends_on "bison" => :build
  depends_on "cmake" => :build
  depends_on "openjdk" => :build
  depends_on "pkgconf" => :build

  depends_on "groonga"
  depends_on "lz4"
  depends_on "lzo"
  depends_on "openssl@3"
  depends_on "pcre2"
  depends_on "xz"
  depends_on "zstd"

  uses_from_macos "bzip2"
  uses_from_macos "krb5"
  uses_from_macos "libxcrypt"
  uses_from_macos "libxml2"
  uses_from_macos "ncurses"
  uses_from_macos "xz"
  uses_from_macos "zlib"

  on_linux do
    depends_on "linux-pam"
  end

  # Backport fix for CMake 4.0
  patch do
    url "https://github.com/MariaDB/server/commit/2a5a12b227845e03575f1b1eb0f6366dccc3e026.patch?full_index=1"
    sha256 "f3a4b5871141451edf3936bcad0861e3a38418c3a8c6a69dfeddb8d073ac3253"
  end
  patch do
    url "https://github.com/codership/wsrep-lib/commit/324b01e4315623ce026688dd9da1a5f921ce7084.patch?full_index=1"
    sha256 "eaa0c3b648b712b3dbab3d37dfca7fef8a072908dc28f2ed383fbe8d217be421"
    directory "wsrep-lib"
  end

  def install
    ENV.runtime_cpu_detection

    # Backport fix for CMake 4.0 in columnstore submodule
    # https://github.com/mariadb-corporation/mariadb-columnstore-engine/commit/726cc3684b4de08934c2b14f347799fd8c3aac9a
    # https://github.com/mariadb-corporation/mariadb-columnstore-engine/commit/7e17d8825409fb8cc0629bfd052ffac6e542b50e
    inreplace "storage/columnstore/columnstore/CMakeLists.txt",
              "CMAKE_MINIMUM_REQUIRED(VERSION 2.8.12)",
              "CMAKE_MINIMUM_REQUIRED(VERSION 3.10)"

    # Set basedir and ldata so that mysql_install_db can find the server
    # without needing an explicit path to be set. This can still
    # be overridden by calling --basedir= when calling.
    inreplace "scripts/mysql_install_db.sh" do |s|
      s.change_make_var! "basedir", "\"#{prefix}\""
      s.change_make_var! "ldata", "\"#{var}/mysql\""
    end

    # Use brew groonga
    rm_r "storage/mroonga/vendor/groonga"

    # -DINSTALL_* are relative to prefix
    args = %W[
      -DMYSQL_DATADIR=#{var}/mysql
      -DINSTALL_INCLUDEDIR=include/mysql
      -DINSTALL_MANDIR=share/man
      -DINSTALL_DOCDIR=share/doc/#{name}
      -DINSTALL_INFODIR=share/info
      -DINSTALL_MYSQLSHAREDIR=share/mysql
      -DWITH_READLINE=yes
      -DWITH_SSL=yes
      -DWITH_UNIT_TESTS=OFF
      -DDEFAULT_CHARSET=utf8mb4
      -DDEFAULT_COLLATION=utf8mb4_general_ci
      -DINSTALL_SYSCONFDIR=#{etc}
      -DCOMPILATION_COMMENT=#{tap.user}
    ]

    if OS.linux?
      args << "-DWITH_NUMA=OFF"
      args << "-DENABLE_DTRACE=NO"
      args << "-DCONNECT_WITH_JDBC=OFF"
    end

    if OS.mac?
      args << "-DWITH_READLINE=NO" # uses libedit on macOS
    end

    # disable TokuDB, which is currently not supported on macOS
    args << "-DPLUGIN_TOKUDB=NO"

    # Disable RocksDB on Apple Silicon (currently not supported)
    args << "-DPLUGIN_ROCKSDB=NO" if Hardware::CPU.arm?

    system "cmake", "-S", ".", "-B", "_build", *std_cmake_args, *args
    system "cmake", "--build", "_build"
    system "cmake", "--install", "_build"

    # Fix my.cnf to point to #{etc} instead of /etc
    (etc/"my.cnf.d").mkpath
    inreplace "#{etc}/my.cnf", "!includedir /etc/my.cnf.d",
                               "!includedir #{etc}/my.cnf.d"
    touch etc/"my.cnf.d/.homebrew_dont_prune_me"

    # Save space
    rm_r(prefix/"mysql-test")
    rm_r(prefix/"sql-bench")

    # Link the setup script into bin
    bin.install_symlink prefix/"scripts/mysql_install_db"

    # Fix up the control script and link into bin
    inreplace "#{prefix}/support-files/mysql.server", /^(PATH=".*)(")/, "\\1:#{HOMEBREW_PREFIX}/bin\\2"

    bin.install_symlink prefix/"support-files/mysql.server"

    # Move sourced non-executable out of bin into libexec
    libexec.install "#{bin}/wsrep_sst_common"
    # Fix up references to wsrep_sst_common
    %w[
      wsrep_sst_mysqldump
      wsrep_sst_rsync
      wsrep_sst_mariabackup
    ].each do |f|
      inreplace "#{bin}/#{f}", "$(dirname \"$0\")/wsrep_sst_common",
                               "#{libexec}/wsrep_sst_common"
    end

    # Install my.cnf that binds to 127.0.0.1 by default
    (buildpath/"my.cnf").write <<~INI
      # Default Homebrew MySQL server config
      [mysqld]
      # Only allow connections from localhost
      bind-address = 127.0.0.1
    INI
    etc.install "my.cnf"
  end

  def post_install
    # Make sure the var/mysql directory exists
    (var/"mysql").mkpath

    # Don't initialize database, it clashes when testing other MySQL-like implementations.
    return if ENV["HOMEBREW_GITHUB_ACTIONS"]

    unless File.exist? "#{var}/mysql/mysql/user.frm"
      ENV["TMPDIR"] = nil
      system bin/"mysql_install_db", "--verbose", "--user=#{ENV["USER"]}",
        "--basedir=#{prefix}", "--datadir=#{var}/mysql", "--tmpdir=/tmp"
    end
  end

  def caveats
    <<~EOS
      A "/etc/my.cnf" from another install may interfere with a Homebrew-built
      server starting up correctly.

      MySQL is configured to only allow connections from localhost by default
    EOS
  end

  service do
    run [opt_bin/"mysqld_safe", "--datadir=#{var}/mysql"]
    keep_alive true
    working_dir var
  end

  test do
    (testpath/"mysql").mkpath
    (testpath/"tmp").mkpath
    system bin/"mysql_install_db", "--no-defaults", "--user=#{ENV["USER"]}",
      "--basedir=#{prefix}", "--datadir=#{testpath}/mysql", "--tmpdir=#{testpath}/tmp",
      "--auth-root-authentication-method=normal"
    port = free_port
    fork do
      system bin/"mysqld", "--no-defaults", "--user=#{ENV["USER"]}",
        "--datadir=#{testpath}/mysql", "--port=#{port}", "--tmpdir=#{testpath}/tmp"
    end
    sleep 5
    assert_match "information_schema",
      shell_output("#{bin}/mysql --port=#{port} --user=root --password= --execute='show databases;'")
    system bin/"mysqladmin", "--port=#{port}", "--user=root", "--password=", "shutdown"
  end
end
