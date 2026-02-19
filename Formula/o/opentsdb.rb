class Opentsdb < Formula
  desc "Scalable, distributed Time Series Database"
  homepage "http://opentsdb.net/"
  url "https://github.com/OpenTSDB/opentsdb/archive/refs/tags/v2.4.1.tar.gz"
  sha256 "70456fa8b33a9f0855105422f944d6ef14d077c4b4c9c26f8e4a86f329b247a0"
  license "LGPL-2.1-or-later"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, sonoma:       "1e94a2ce5cc95c944f5763df3442cc2fe71d12279f134b0a051549c6b4bd902a"
    sha256 cellar: :any_skip_relocation, ventura:      "022671a452bff9bacb3c84213f26adfb9d4fc50bdfbd28e2997262f6f5936607"
    sha256 cellar: :any_skip_relocation, arm64_linux:  "e3cb78193f508228b2918205e3c4303febb1c2dd525e4a6f8d503866b41407f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "8c51dd6ebd008e6868a745d85dfe01374ef3b4e3ada22a54d4015d89e7973443"
  end

  # Deprecated since:
  # * No arm64 macOS support: https://docs.brew.sh/Support-Tiers#future-macos-support
  # * CVE in stable release: https://nvd.nist.gov/vuln/detail/CVE-2023-36812
  # * Still needs OpenJDK 8 to build
  deprecate! date: "2025-09-25", because: :unmaintained
  disable! date: "2026-09-25", because: :unmaintained

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "openjdk@8" => :build
  depends_on "python@3.13" => :build
  depends_on "gnuplot"
  depends_on "hbase"
  depends_on "lzo"
  depends_on "openjdk@11"

  on_macos do
    depends_on arch: :x86_64 # openjdk@8 (needed to build) is not supported on ARM
  end

  def install
    with_env(JAVA_HOME: Language::Java.java_home("1.8")) do
      ENV.prepend_path "PATH", Formula["python@3.13"].opt_libexec/"bin"
      system "autoreconf", "--force", "--install", "--verbose"
      system "./configure", "--disable-silent-rules",
                            "--localstatedir=#{var}/opentsdb",
                            "--mandir=#{man}",
                            "--sysconfdir=#{etc}",
                            *std_configure_args
      system "make"
      bin.mkpath
      (pkgshare/"static/gwt/opentsdb/images/ie6").mkpath
      ENV.deparallelize { system "make", "install" }
    end

    env = Language::Java.java_home_env("11")
    env["PATH"] = "$JAVA_HOME/bin:$PATH"
    env["HBASE_HOME"] = Formula["hbase"].opt_libexec
    # We weren't able to get HBase native LZO compression working in Monterey
    env["COMPRESSION"] = (OS.mac? && MacOS.version >= :monterey) ? "NONE" : "LZO"

    create_table = pkgshare/"tools/create_table_with_env.sh"
    create_table.write_env_script pkgshare/"tools/create_table.sh", env
    create_table.chmod 0755

    inreplace pkgshare/"etc/opentsdb/opentsdb.conf", "/usr/share", "#{HOMEBREW_PREFIX}/share"
    etc.install pkgshare/"etc/opentsdb"
    (pkgshare/"plugins/.keep").write ""

    (bin/"start-tsdb.sh").write <<~SH
      #!/bin/sh
      exec "#{opt_bin}/tsdb" tsd \\
        --config="#{etc}/opentsdb/opentsdb.conf" \\
        --staticroot="#{opt_pkgshare}/static/" \\
        --cachedir="#{var}/cache/opentsdb" \\
        --port=4242 \\
        --zkquorum=localhost:2181 \\
        --zkbasedir=/hbase \\
        --auto-metric \\
        "$@"
    SH
    (bin/"start-tsdb.sh").chmod 0755

    libexec.mkpath
    bin.env_script_all_files(libexec, env)
  end

  def post_install
    (var/"cache/opentsdb").mkpath
    system "#{Formula["hbase"].opt_bin}/start-hbase.sh"
    begin
      sleep 2
      system "#{pkgshare}/tools/create_table_with_env.sh"
    ensure
      system "#{Formula["hbase"].opt_bin}/stop-hbase.sh"
    end
  end

  service do
    run opt_bin/"start-tsdb.sh"
    working_dir HOMEBREW_PREFIX
    log_path var/"opentsdb/opentsdb.log"
    error_log_path var/"opentsdb/opentsdb.err"
  end

  test do
    cp_r (Formula["hbase"].opt_libexec/"conf"), testpath
    inreplace (testpath/"conf/hbase-site.xml") do |s|
      s.gsub!(/(hbase.rootdir.*)\n.*/, "\\1\n<value>file://#{testpath}/hbase</value>")
      s.gsub!(/(hbase.zookeeper.property.dataDir.*)\n.*/, "\\1\n<value>#{testpath}/zookeeper</value>")
    end

    ENV.prepend "_JAVA_OPTIONS", "-Djava.io.tmpdir=#{testpath}/tmp"
    ENV["HBASE_LOG_DIR"]  = testpath/"logs"
    ENV["HBASE_CONF_DIR"] = testpath/"conf"
    ENV["HBASE_PID_DIR"]  = testpath/"pid"

    system Formula["hbase"].opt_bin/"start-hbase.sh"
    begin
      sleep 10

      system pkgshare/"tools/create_table_with_env.sh"

      tsdb_err = testpath/"tsdb.err"
      tsdb_out = testpath/"tsdb.out"
      fork do
        $stderr.reopen(tsdb_err, "w")
        $stdout.reopen(tsdb_out, "w")
        exec("#{bin}/start-tsdb.sh")
      end
      sleep 15

      TCPSocket.open("localhost", 4242) do |sock|
        sock.puts("put homebrew.install.test 1356998400 42.5 host=webserver01 cpu=0\n")
      ensure
        sock.close
      end

      system bin/"tsdb", "query", "1356998000", "1356999000", "sum",
             "homebrew.install.test", "host=webserver01", "cpu=0"
    ensure
      system "#{Formula["hbase"].opt_bin}/stop-hbase.sh"
    end
  end
end
