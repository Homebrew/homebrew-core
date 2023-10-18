class Mysql < Formula
  desc "Open source relational database management system"
  homepage "https://dev.mysql.com/doc/refman/8.0/en/"
  # TODO: Check if we can use unversioned `protobuf` at version bump
  # https://bugs.mysql.com/bug.php?id=111469
  url "https://cdn.mysql.com/Downloads/MySQL-8.1/mysql-boost-8.1.0.tar.gz"
  sha256 "cb19648bc8719b9f6979924bfea806b278bd26b8d67740e5742c6f363f142188"
  license "GPL-2.0-only" => { with: "Universal-FOSS-exception-1.0" }

  livecheck do
    url "https://dev.mysql.com/downloads/mysql/?tpl=files&os=src"
    regex(/href=.*?mysql[._-](?:boost[._-])?v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "8c32b652561e2f3efb888d83d7df34ec6b5dc6de5c1509a8d123a8fb7ccc472d"
    sha256 arm64_ventura:  "2635ebe1066a0dc5c34337fe81d9872833b0f5e9d559a8703ca07b1822ccf0d4"
    sha256 arm64_monterey: "1b4ef2d450f423881120a6ac35e8b87d012edaff7fd6e5a88ab6cccba1c87ab4"
    sha256 arm64_big_sur:  "57e60dd46e6787de2d331ae73c0b5f5a7179d2e325560305100f4bb09bef429b"
    sha256 sonoma:         "2239fec2ec6cedcb46923af7fd52326b7d904a737f67d3a06fa091066dcb778e"
    sha256 ventura:        "6630ef74b2ec3554edcf4f02428e3a14a155961648bdda7cfcc029e4bc90c2b3"
    sha256 monterey:       "45d0bc945be3a357f18283cdf39afffb48a9e9b1800ac44b1e07ebec1ee6af1d"
    sha256 big_sur:        "184d9881c8d6e1fce906cbafca1fedc8edffefea8c892a04cf5ce54cd4d5b08a"
    sha256 x86_64_linux:   "f9a1199c55cd9583a08fd320ef5df5c80ad6700965f2d5fdbd5b3ca03524089d"
  end

  depends_on "bison" => :build
  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "icu4c"
  depends_on "libevent"
  depends_on "libfido2"
  depends_on "lz4"
  depends_on "openssl@3"
  depends_on "protobuf@21" # percona-xtrabackup dependency conflict
  depends_on "zlib" # Zlib 1.2.12+
  depends_on "zstd"

  uses_from_macos "curl"
  uses_from_macos "cyrus-sasl"
  uses_from_macos "libedit"

  on_linux do
    depends_on "patchelf" => :build
    depends_on "libtirpc"
  end

  conflicts_with "mariadb", "percona-server",
    because: "mysql, mariadb, and percona install the same binaries"

  fails_with gcc: "5" # for C++17

  # Patch out check for Homebrew `boost`.
  # This should not be necessary when building inside `brew`.
  # https://github.com/Homebrew/homebrew-test-bot/pull/820
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/030f7433e89376ffcff836bb68b3903ab90f9cdc/mysql/boost-check.patch"
    sha256 "af27e4b82c84f958f91404a9661e999ccd1742f57853978d8baec2f993b51153"
  end

  # Fix for "Cannot find system zlib libraries" even though they are installed.
  # https://bugs.mysql.com/bug.php?id=110745
  patch :DATA

  def datadir
    var/"mysql"
  end

  def install
    if OS.linux?
      # Fix libmysqlgcs.a(gcs_logging.cc.o): relocation R_X86_64_32
      # against `_ZN17Gcs_debug_options12m_debug_noneB5cxx11E' can not be used when making
      # a shared object; recompile with -fPIC
      ENV.append_to_cflags "-fPIC"

      # Disable ABI checking
      inreplace "cmake/abi_check.cmake", "RUN_ABI_CHECK 1", "RUN_ABI_CHECK 0"
    end

    # -DINSTALL_* are relative to `CMAKE_INSTALL_PREFIX` (`prefix`)
    args = %W[
      -DCOMPILATION_COMMENT=Homebrew
      -DINSTALL_DOCDIR=share/doc/#{name}
      -DINSTALL_INCLUDEDIR=include/mysql
      -DINSTALL_INFODIR=share/info
      -DINSTALL_MANDIR=share/man
      -DINSTALL_MYSQLSHAREDIR=share/mysql
      -DINSTALL_PLUGINDIR=lib/plugin
      -DMYSQL_DATADIR=#{datadir}
      -DSYSCONFDIR=#{etc}
      -DWITH_SYSTEM_LIBS=ON
      -DWITH_BOOST=boost
      -DWITH_EDITLINE=system
      -DWITH_FIDO=system
      -DWITH_ICU=system
      -DWITH_LIBEVENT=system
      -DWITH_LZ4=system
      -DWITH_PROTOBUF=system
      -DWITH_SSL=system
      -DWITH_ZLIB=system
      -DWITH_ZSTD=system
      -DWITH_UNIT_TESTS=OFF
      -DENABLED_LOCAL_INFILE=1
      -DWITH_INNODB_MEMCACHED=ON
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    # Fix bad linker flags in `mysql_config`.
    # https://bugs.mysql.com/bug.php?id=111011
    inreplace bin/"mysql_config", "-lzlib", "-lz"

    (prefix/"mysql-test").cd do
      system "./mysql-test-run.pl", "status", "--vardir=#{Dir.mktmpdir}"
    end

    # Remove the tests directory
    rm_rf prefix/"mysql-test"

    # Don't create databases inside of the prefix!
    # See: https://github.com/Homebrew/homebrew/issues/4975
    rm_rf prefix/"data"

    # Fix up the control script and link into bin.
    inreplace "#{prefix}/support-files/mysql.server",
              /^(PATH=".*)(")/,
              "\\1:#{HOMEBREW_PREFIX}/bin\\2"
    bin.install_symlink prefix/"support-files/mysql.server"

    # Install my.cnf that binds to 127.0.0.1 by default
    (buildpath/"my.cnf").write <<~EOS
      # Default Homebrew MySQL server config
      [mysqld]
      # Only allow connections from localhost
      bind-address = 127.0.0.1
      mysqlx-bind-address = 127.0.0.1
    EOS
    etc.install "my.cnf"
  end

  def post_install
    # Make sure the var/mysql directory exists
    (var/"mysql").mkpath

    # Don't initialize database, it clashes when testing other MySQL-like implementations.
    return if ENV["HOMEBREW_GITHUB_ACTIONS"]

    unless (datadir/"mysql/general_log.CSM").exist?
      ENV["TMPDIR"] = nil
      system bin/"mysqld", "--initialize-insecure", "--user=#{ENV["USER"]}",
        "--basedir=#{prefix}", "--datadir=#{datadir}", "--tmpdir=/tmp"
    end
  end

  def caveats
    s = <<~EOS
      We've installed your MySQL database without a root password. To secure it run:
          mysql_secure_installation

      MySQL is configured to only allow connections from localhost by default

      To connect run:
          mysql -u root
    EOS
    if (my_cnf = ["/etc/my.cnf", "/etc/mysql/my.cnf"].find { |x| File.exist? x })
      s += <<~EOS

        A "#{my_cnf}" from another install may interfere with a Homebrew-built
        server starting up correctly.
      EOS
    end
    s
  end

  service do
    run [opt_bin/"mysqld_safe", "--datadir=#{var}/mysql"]
    keep_alive true
    working_dir var/"mysql"
  end

  test do
    (testpath/"mysql").mkpath
    (testpath/"tmp").mkpath
    system bin/"mysqld", "--no-defaults", "--initialize-insecure", "--user=#{ENV["USER"]}",
      "--basedir=#{prefix}", "--datadir=#{testpath}/mysql", "--tmpdir=#{testpath}/tmp"
    port = free_port
    fork do
      system "#{bin}/mysqld", "--no-defaults", "--user=#{ENV["USER"]}",
        "--datadir=#{testpath}/mysql", "--port=#{port}", "--tmpdir=#{testpath}/tmp"
    end
    sleep 5
    assert_match "information_schema",
      shell_output("#{bin}/mysql --port=#{port} --user=root --password= --execute='show databases;'")
    system "#{bin}/mysqladmin", "--port=#{port}", "--user=root", "--password=", "shutdown"
  end
end

__END__
diff --git a/cmake/zlib.cmake b/cmake/zlib.cmake
index 460d87a..36fbd60 100644
--- a/cmake/zlib.cmake
+++ b/cmake/zlib.cmake
@@ -50,7 +50,7 @@ FUNCTION(FIND_ZLIB_VERSION ZLIB_INCLUDE_DIR)
   MESSAGE(STATUS "ZLIB_INCLUDE_DIR ${ZLIB_INCLUDE_DIR}")
 ENDFUNCTION(FIND_ZLIB_VERSION)
 
-FUNCTION(FIND_SYSTEM_ZLIB)
+MACRO(FIND_SYSTEM_ZLIB)
   FIND_PACKAGE(ZLIB)
   IF(ZLIB_FOUND)
     ADD_LIBRARY(zlib_interface INTERFACE)
@@ -61,7 +61,7 @@ FUNCTION(FIND_SYSTEM_ZLIB)
         ${ZLIB_INCLUDE_DIR})
     ENDIF()
   ENDIF()
-ENDFUNCTION(FIND_SYSTEM_ZLIB)
+ENDMACRO(FIND_SYSTEM_ZLIB)
 
 MACRO (RESET_ZLIB_VARIABLES)
   # Reset whatever FIND_PACKAGE may have left behind.
