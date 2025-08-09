class PerconaServerAT80 < Formula
  desc "Drop-in MySQL replacement"
  homepage "https://www.percona.com"
  url "https://downloads.percona.com/downloads/Percona-Server-8.0/Percona-Server-8.0.42-33/source/tarball/percona-server-8.0.42-33.tar.gz"
  sha256 "503766073d515635ff9118afbe4ebd18f76d8cb8d64e094ac6d7a22f15ca4067"
  license "BSD-3-Clause"
  revision 2

  livecheck do
    url "https://www.percona.com/products-api.php", post_form: {
      version: "Percona-Server-#{version.major_minor}",
    }
    regex(/value=["']?[^"' >]*?v?(\d+(?:[.-]\d+)+)[|"' >]/i)
    strategy :page_match do |page, regex|
      page.scan(regex).map do |match|
        # Convert a version like 1.2.3-4.0 to 1.2.3-4 (but leave a version like
        # 1.2.3-4.5 as-is).
        match[0].sub(/(-\d+)\.0$/, '\1')
      end
    end
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 arm64_sequoia: "7b1002246589a8cfbf9102152835a3435dce2a4b37c26a77f06216125fabb66d"
    sha256 arm64_sonoma:  "00f8cdf306efa94f8c8763c181e2278b892e3b48c9891c4fadcad0a8b343d5e8"
    sha256 arm64_ventura: "1a47898c44c61de80bcc8a46bbee0af1821bc7fb6fc221b5209a58e03ed2d7b0"
    sha256 sonoma:        "91081c2a20329bbb1bba4e719be9dfba8d69e20a843bb63d5d9f20a2aefc12ed"
    sha256 ventura:       "662d3761aa71fc5456d169d388e4349f58df6f6131996cc3218bee91f910847e"
    sha256 arm64_linux:   "e750f499c5a9b3dcdb319aea22b6d2fc717a6afec3b10051b69624670352c433"
    sha256 x86_64_linux:  "3a6fd35b3d361efa1320f467b04085f0501b8d360bbb63c28442c48bc0b69e37"
  end

  keg_only :versioned_formula

  depends_on "bison" => :build
  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "abseil"
  depends_on "icu4c@77"
  depends_on "libevent"
  depends_on "libfido2"
  depends_on "lz4"
  depends_on "openldap" # Needs `ldap_set_urllist_proc`, not provided by LDAP.framework
  depends_on "openssl@3"
  depends_on "protobuf@29"
  depends_on "zlib" # Zlib 1.2.13+
  depends_on "zstd"

  uses_from_macos "curl"
  uses_from_macos "cyrus-sasl"
  uses_from_macos "krb5"
  uses_from_macos "libedit"

  on_linux do
    depends_on "patchelf" => :build
    depends_on "libtirpc"
  end

  # https://github.com/percona/percona-server/blob/8.0/cmake/os/Darwin.cmake
  fails_with :clang do
    build 999
    cause "Requires Apple Clang 10.0 or newer"
  end

  # https://github.com/percona/percona-server/blob/Percona-Server-#{version}/cmake/boost.cmake
  resource "boost" do
    url "https://downloads.sourceforge.net/project/boost/boost/1.77.0/boost_1_77_0.tar.bz2"
    sha256 "fc9f85fc030e233142908241af7a846e60630aa7388de9a5fafb1f3a26840854"

    livecheck do
      url "https://raw.githubusercontent.com/percona/percona-server/refs/tags/Percona-Server-#{LATEST_VERSION}/cmake/boost.cmake"
      regex(%r{/release/v?(\d+(?:\.\d+)+)/}i)
    end
  end

  # Patch out check for Homebrew `boost`.
  # This should not be necessary when building inside `brew`.
  # https://github.com/Homebrew/homebrew-test-bot/pull/820
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/030f7433e89376ffcff836bb68b3903ab90f9cdc/mysql/boost-check.patch"
    sha256 "af27e4b82c84f958f91404a9661e999ccd1742f57853978d8baec2f993b51153"
  end

  # Fix for system ssl add_library error
  # Issue ref: https://perconadev.atlassian.net/jira/software/c/projects/PS/issues/PS-9641
  patch do
    url "https://github.com/percona/percona-server/commit/a693e5d67abf6f27f5284c86361604babec529c6.patch?full_index=1"
    sha256 "d4afcdfb0dd8dcb7c0f7e380a88605b515874628107295ab5b892e8f1e019604"
  end

  # FreeBSD patches for fixing build failure with newer clang
  patch :p0 do
    url "https://raw.githubusercontent.com/freebsd/freebsd-ports/1a02a961a2d53f21bf208f07903a97cc46f43e17/databases/mysql80-server/files/patch-sql_binlog__ostream.cc"
    sha256 "16f86edd2daf5f6c87616781c9f51f76d4a695d55b354e44d639a823b1c3f681"
  end

  patch :p0 do
    url "https://raw.githubusercontent.com/freebsd/freebsd-ports/1a02a961a2d53f21bf208f07903a97cc46f43e17/databases/mysql80-server/files/patch-sql_mdl__context__backup.cc"
    sha256 "501646e1cb6ac2ddc5eb42755d340443e4655741d6e76788f48751a2fb8f3775"
  end

  patch :p0 do
    url "https://raw.githubusercontent.com/freebsd/freebsd-ports/1a02a961a2d53f21bf208f07903a97cc46f43e17/databases/mysql80-server/files/patch-sql_mdl__context__backup.h"
    sha256 "e515b565d1501648ce3de0add12b67c63aecb3ec4db3794de72c4eeb301ff343"
  end

  patch :p0 do
    url "https://raw.githubusercontent.com/freebsd/freebsd-ports/1a02a961a2d53f21bf208f07903a97cc46f43e17/databases/mysql80-server/files/patch-sql_range__optimizer_index__range__scan__plan.cc"
    sha256 "44b5e76373fadd97560d66dae0dac14d98ae9a5c32d58d876bfe694016872bc7"
  end

  patch :p0 do
    url "https://raw.githubusercontent.com/freebsd/freebsd-ports/1a02a961a2d53f21bf208f07903a97cc46f43e17/databases/mysql80-server/files/patch-sql_rpl__log__encryption.cc"
    sha256 "bdadcf4317295d1847283e20dd7fbfa2df2c4acebf45d5a13d0670bc7311f7ba"
  end

  patch :p0 do
    url "https://raw.githubusercontent.com/freebsd/freebsd-ports/1a02a961a2d53f21bf208f07903a97cc46f43e17/databases/mysql80-server/files/patch-sql_stream__cipher.cc"
    sha256 "ac74c60f6051223993c88e7a11ddd9512c951ac1401d719a2c3377efe1bee3cf"
  end

  patch :p0 do
    url "https://raw.githubusercontent.com/freebsd/freebsd-ports/1a02a961a2d53f21bf208f07903a97cc46f43e17/databases/mysql80-server/files/patch-sql_stream__cipher.h"
    sha256 "9a11d4658f60a63f3f10ff97a5170e865afde3ebee3e703d8272aba3cf6e32d0"
  end

  patch :p0 do
    url "https://raw.githubusercontent.com/freebsd/freebsd-ports/1a02a961a2d53f21bf208f07903a97cc46f43e17/databases/mysql80-server/files/patch-unittest_gunit_binlogevents_transaction__compression-t.cc"
    sha256 "3bd0c22a2ee30a7b1e682e645dbdf473d4f0d6f8e5ffc447f088c5f1bf21efd7"
  end

  patch :p0 do
    url "https://raw.githubusercontent.com/freebsd/freebsd-ports/1a02a961a2d53f21bf208f07903a97cc46f43e17/databases/mysql80-server/files/patch-unittest_gunit_stream__cipher-t.cc"
    sha256 "9e7629a2174e754487737ef0d73c79fc1ed47ba54a982a3a4803e19c72c5dc0f"
  end

  # More fixes for new clang not covered by the FreeBSD patches.
  patch :DATA

  def datadir
    var/"mysql"
  end

  def install
    # Remove bundled libraries other than explicitly allowed below.
    # `boost` and `rapidjson` must use bundled copy due to patches.
    # `lz4` is still needed due to xxhash.c used by mysqlgcs
    # FIXME: Try to get rid of these other bundled libraries.
    keep = %w[coredumper duktape libkmip lz4 opensslpp rapidjson robin-hood-hashing unordered_dense
              xxhash libbacktrace]
    (buildpath/"extra").each_child { |dir| rm_r(dir) unless keep.include?(dir.basename.to_s) }
    (buildpath/"boost").install resource("boost")

    # Find Homebrew OpenLDAP instead of the macOS framework
    inreplace "cmake/ldap.cmake", "NAMES ldap_r ldap", "NAMES ldap"

    # Fix mysqlrouter_passwd RPATH to link to metadata_cache.so
    inreplace "router/src/http/src/CMakeLists.txt",
              "ADD_INSTALL_RPATH(mysqlrouter_passwd \"${ROUTER_INSTALL_RPATH}\")",
              "\\0\nADD_INSTALL_RPATH(mysqlrouter_passwd \"${RPATH_ORIGIN}/../${ROUTER_INSTALL_PLUGINDIR}\")"

    # Disable ABI checking
    inreplace "cmake/abi_check.cmake", "RUN_ABI_CHECK 1", "RUN_ABI_CHECK 0" if OS.linux?

    icu4c = deps.find { |dep| dep.name.match?(/^icu4c(@\d+)?$/) }
                .to_formula
    # -DINSTALL_* are relative to `CMAKE_INSTALL_PREFIX` (`prefix`)
    args = %W[
      -DCOMPILATION_COMMENT=Homebrew
      -DDEFAULT_CHARSET=utf8mb4
      -DDEFAULT_COLLATION=utf8mb4_0900_ai_ci
      -DINSTALL_DOCDIR=share/doc/#{name}
      -DINSTALL_INCLUDEDIR=include/mysql
      -DINSTALL_INFODIR=share/info
      -DINSTALL_MANDIR=share/man
      -DINSTALL_MYSQLSHAREDIR=share/mysql
      -DINSTALL_PLUGINDIR=lib/percona-server/plugin
      -DMYSQL_DATADIR=#{datadir}
      -DSYSCONFDIR=#{etc}
      -DBISON_EXECUTABLE=#{Formula["bison"].opt_bin}/bison
      -DOPENSSL_ROOT_DIR=#{Formula["openssl@3"].opt_prefix}
      -DWITH_ICU=#{icu4c.opt_prefix}
      -DWITH_SYSTEM_LIBS=ON
      -DWITH_BOOST=#{buildpath}/boost
      -DWITH_EDITLINE=system
      -DWITH_FIDO=system
      -DWITH_LIBEVENT=system
      -DWITH_LZ4=system
      -DWITH_PROTOBUF=system
      -DWITH_SSL=system
      -DWITH_ZLIB=system
      -DWITH_ZSTD=system
      -DWITH_UNIT_TESTS=OFF
      -DWITH_INNODB_MEMCACHED=ON
      -DROCKSDB_BUILD_ARCH=#{ENV.effective_arch}
      -DALLOW_NO_ARMV81A_CRYPTO=ON
      -DALLOW_NO_SSE42=ON
    ]
    args << "-DROCKSDB_DISABLE_AVX2=ON" if build.bottle?
    args << "-DWITH_KERBEROS=system" unless OS.mac?

    ENV.append "CXXFLAGS", "-std=c++17"

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    cd prefix/"mysql-test" do
      test_args = ["--vardir=#{buildpath}/mysql-test-vardir"]
      # For Linux, disable failing on warning: "Setting thread 31563 nice to 0 failed"
      # Docker containers lack CAP_SYS_NICE capability by default.
      test_args << "--nowarnings" if OS.linux?
      system "./mysql-test-run.pl", "check", *test_args
    ensure
      status_log_file = buildpath/"mysql-test-vardir/log/main.status/status.log"
      logs.install status_log_file if status_log_file.exist?
    end

    # Remove the tests directory
    rm_r(prefix/"mysql-test")

    # Fix up the control script and link into bin.
    inreplace prefix/"support-files/mysql.server",
              /^(PATH=".*)(")/,
              "\\1:#{HOMEBREW_PREFIX}/bin\\2"
    bin.install_symlink prefix/"support-files/mysql.server"

    # Install my.cnf that binds to 127.0.0.1 by default
    (buildpath/"my.cnf").write <<~INI
      # Default Homebrew MySQL server config
      [mysqld]
      # Only allow connections from localhost
      bind-address = 127.0.0.1
      mysqlx-bind-address = 127.0.0.1
    INI
    etc.install "my.cnf"
  end

  def post_install
    # Make sure the var/mysql directory exists
    (var/"mysql").mkpath

    if (my_cnf = ["/etc/my.cnf", "/etc/mysql/my.cnf"].find { |x| File.exist? x })
      opoo <<~EOS

        A "#{my_cnf}" from another install may interfere with a Homebrew-built
        server starting up correctly.
      EOS
    end

    # Don't initialize database, it clashes when testing other MySQL-like implementations.
    return if ENV["HOMEBREW_GITHUB_ACTIONS"]

    unless (datadir/"mysql/general_log.CSM").exist?
      ENV["TMPDIR"] = nil
      system bin/"mysqld", "--initialize-insecure", "--user=#{ENV["USER"]}",
                           "--basedir=#{prefix}", "--datadir=#{datadir}", "--tmpdir=/tmp"
    end
  end

  def caveats
    <<~EOS
      We've installed your MySQL database without a root password. To secure it run:
          mysql_secure_installation

      MySQL is configured to only allow connections from localhost by default

      To connect run:
          mysql -u root
    EOS
  end

  service do
    run [opt_bin/"mysqld_safe", "--datadir=#{var}/mysql"]
    keep_alive true
    working_dir var/"mysql"
  end

  test do
    (testpath/"mysql").mkpath
    (testpath/"tmp").mkpath

    port = free_port
    socket = testpath/"mysql.sock"
    mysqld_args = %W[
      --no-defaults
      --mysqlx=OFF
      --user=#{ENV["USER"]}
      --port=#{port}
      --socket=#{socket}
      --basedir=#{prefix}
      --datadir=#{testpath}/mysql
      --tmpdir=#{testpath}/tmp
    ]
    client_args = %W[
      --port=#{port}
      --socket=#{socket}
      --user=root
      --password=
    ]

    system bin/"mysqld", *mysqld_args, "--initialize-insecure"
    pid = spawn(bin/"mysqld", *mysqld_args)
    begin
      sleep 5
      output = shell_output("#{bin}/mysql #{client_args.join(" ")} --execute='show databases;'")
      assert_match "information_schema", output
    ensure
      system bin/"mysqladmin", *client_args, "shutdown"
      Process.kill "TERM", pid
    end
  end
end

__END__
diff --git i/sql/mf_iocache.cc w/sql/mf_iocache.cc
index 4a7695ff..f640f5a5 100644
--- i/sql/mf_iocache.cc
+++ w/sql/mf_iocache.cc
@@ -110,7 +110,7 @@ bool open_cached_file_encrypted(IO_CACHE *cache, const char *dir,
 
   /* Generate password, it is a random string. */
   if (my_rand_buffer(password, sizeof(password)) != 0) DBUG_RETURN(true);
-  password_str.append(password, sizeof(password));
+  password_str.insert(password_str.end(), password, password + sizeof(password));
 
   auto encryptor = std::make_unique<Aes_ctr_encryptor>();
   if (encryptor->open(password_str, 0)) DBUG_RETURN(true);
