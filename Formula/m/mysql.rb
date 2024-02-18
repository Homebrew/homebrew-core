class Mysql < Formula
  desc "Open source relational database management system"
  homepage "https://dev.mysql.com/doc/refman/8.3/en/"
  url "https://cdn.mysql.com/Downloads/MySQL-8.3/mysql-boost-8.3.0.tar.gz"
  sha256 "f0a73556b8a417bc4dc6d2d78909080512beb891930cd93d0740d22207be285b"
  license "GPL-2.0-only" => { with: "Universal-FOSS-exception-1.0" }

  livecheck do
    url "https://dev.mysql.com/downloads/mysql/?tpl=files&os=src"
    regex(/href=.*?mysql[._-](?:boost[._-])?v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "df6bc0e2467aed916538af13b4ce986f8fea0203f658f8b7586a9ddacfc2c5f8"
    sha256 arm64_ventura:  "609d00709f802617db96f42f2582bfc4494fd6c2089dadf2634b9e4bc181085e"
    sha256 arm64_monterey: "db4c782d5bac5c27a8da039cb507eb94756a615e3620a56793b84db8d2543be2"
    sha256 sonoma:         "6823121559fb6528370d62ba41bd8449679ecb3cf21c04d5487d83695b896c42"
    sha256 ventura:        "0e5a7a6b47bf2e9dfe9aad4a196d49530c0419bdcb6a237a9bbfbe5cc5b63524"
    sha256 monterey:       "4875dc21e06005512e6d8a5e810fb21d1a15173a662b9dd9464c11b909c2401e"
    sha256 x86_64_linux:   "722de4bb10a9676cd5e71c6442ed4546409c089d6998b0e56f957272f16a25c5"
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
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/bd61f2edc4c551856f894d307140b855edb2b4f5/mysql/boost-check.patch"
    sha256 "b90c6f78fa347cec6388d2419ee4bc9a5dc9261771eff2800d99610e1c449244"
  end

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
      -DWITH_INNODB_MEMCACHED=ON
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

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
