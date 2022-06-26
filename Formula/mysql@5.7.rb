class MysqlAT57 < Formula
  desc "Open source relational database management system"
  homepage "https://dev.mysql.com/doc/refman/5.7/en/"
  url "https://cdn.mysql.com/Downloads/MySQL-5.7/mysql-boost-5.7.38.tar.gz"
  sha256 "89d2c42aaa7fd2e31f33b21c5619d2b4c7e1dc2081f820f9f6eec2f30c5fbbf8"
  license "GPL-2.0-only"

  livecheck do
    url "https://dev.mysql.com/downloads/mysql/5.7.html?tpl=files&os=src&version=5.7"
    regex(/href=.*?mysql[._-](?:boost[._-])?v?(5\.7(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "3c0acf8ec8261fb566698d24f8812b7393aed682213fa1f551cd3736c0f933d1"
    sha256 arm64_big_sur:  "69fd8ebc670790c8c00adcc4fb0745e103d0b5aa5a7ae4d3569ce4272bdb5766"
    sha256 monterey:       "ad4b3ffeb40b1864b5d519003f4aefae28c9a25d034d6fdd5e6feecdfb29bfe3"
    sha256 big_sur:        "926681492ac45b200b034f9ccab34e85d30a5612d3672e4a7b19d0cffa545379"
    sha256 catalina:       "77200927c2cdc73db992c105ecedec9027098cf7ad98d25a859f829edb19b51c"
    sha256 x86_64_linux:   "24d14fba74969405696af96393cb6a9c10a8df4801d19ff1098fb1a9c997a835"
  end

  keg_only :versioned_formula

  depends_on "cmake" => :build
  depends_on "openssl@1.1"

  uses_from_macos "libedit"

  on_linux do
    depends_on "pkg-config" => :build
  end

  def datadir
    var/"mysql"
  end

  # Fixes loading of VERSION file, backported from mysql/mysql-server@51675dd
  patch :DATA

  def install
    if OS.linux?
      # Fix libmysqlgcs.a(gcs_logging.cc.o): relocation R_X86_64_32
      # against `_ZN17Gcs_debug_options12m_debug_noneB5cxx11E' can not be used when making
      # a shared object; recompile with -fPIC
      ENV.append_to_cflags "-fPIC"
    end

    # Fixes loading of VERSION file; used in conjunction with patch
    File.rename "VERSION", "MYSQL_VERSION"

    # -DINSTALL_* are relative to `CMAKE_INSTALL_PREFIX` (`prefix`)
    args = %W[
      -DCOMPILATION_COMMENT=Homebrew
      -DDEFAULT_CHARSET=utf8
      -DDEFAULT_COLLATION=utf8_general_ci
      -DINSTALL_DOCDIR=share/doc/#{name}
      -DINSTALL_INCLUDEDIR=include/mysql
      -DINSTALL_INFODIR=share/info
      -DINSTALL_MANDIR=share/man
      -DINSTALL_MYSQLSHAREDIR=share/mysql
      -DINSTALL_PLUGINDIR=lib/plugin
      -DMYSQL_DATADIR=#{datadir}
      -DSYSCONFDIR=#{etc}
      -DWITH_BOOST=boost
      -DWITH_EDITLINE=system
      -DWITH_SSL=yes
      -DWITH_NUMA=OFF
      -DWITH_UNIT_TESTS=OFF
      -DWITH_EMBEDDED_SERVER=ON
      -DENABLED_LOCAL_INFILE=1
      -DWITH_INNODB_MEMCACHED=ON
    ]

    args << "-DENABLE_DTRACE=0" if OS.linux?

    system "cmake", ".", *std_cmake_args, *args
    system "make"
    system "make", "install"

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
          mysql -uroot
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
diff --git a/cmake/mysql_version.cmake b/cmake/mysql_version.cmake
index 43d731e..3031258 100644
--- a/cmake/mysql_version.cmake
+++ b/cmake/mysql_version.cmake
@@ -31,7 +31,7 @@ SET(DOT_FRM_VERSION "6")
 
 # Generate "something" to trigger cmake rerun when VERSION changes
 CONFIGURE_FILE(
-  ${CMAKE_SOURCE_DIR}/VERSION
+  ${CMAKE_SOURCE_DIR}/MYSQL_VERSION
   ${CMAKE_BINARY_DIR}/VERSION.dep
 )
 
@@ -39,7 +39,7 @@ CONFIGURE_FILE(
 
 MACRO(MYSQL_GET_CONFIG_VALUE keyword var)
  IF(NOT ${var})
-   FILE (STRINGS ${CMAKE_SOURCE_DIR}/VERSION str REGEX "^[ ]*${keyword}=")
+   FILE (STRINGS ${CMAKE_SOURCE_DIR}/MYSQL_VERSION str REGEX "^[ ]*${keyword}=")
    IF(str)
      STRING(REPLACE "${keyword}=" "" str ${str})
      STRING(REGEX REPLACE  "[ ].*" ""  str "${str}")

