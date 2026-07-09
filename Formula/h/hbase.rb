class Hbase < Formula
  desc "Hadoop database: a distributed, scalable, big data store"
  homepage "https://hbase.apache.org"
  url "https://www.apache.org/dyn/closer.lua?path=hbase/2.6.6/hbase-2.6.6-bin.tar.gz"
  mirror "https://archive.apache.org/dist/hbase/2.6.6/hbase-2.6.6-bin.tar.gz"
  sha256 "cbcfbfed6411cf898961133c228dcdb4beeb155a611e503ccb212e6f08abec00"
  # We bundle hadoop-lzo which is GPL-3.0-or-later
  license all_of: ["Apache-2.0", "GPL-3.0-or-later"]

  bottle do
    sha256 arm64_tahoe:   "8fe2578bdd1fb4288530b15721d72679a44c1f535a2ceaf7d85a8a5dd25aa0d0"
    sha256 arm64_sequoia: "ec96d394f1a20747f38c0e874c0ac72fe012614b6f3ebbd46a7093d322ad3bc9"
    sha256 arm64_sonoma:  "89d8151ecf120d5228473ea835540c50b4dac5abd2a996346eff9d0a4c78ea97"
    sha256 sonoma:        "6cad68272975fe6ea1bfa854c430e3b1201cb115c9a9717b8b6759bea661d9bc"
    sha256 arm64_linux:   "08dbb999a86cfaa7662a3fa990434f862e59a38ebf7e5a643a06540e9ed1df58"
    sha256 x86_64_linux:  "a459a717fb035af4541cfea2ee9acda0d06076ff03e475e166497120030c4638"
  end

  depends_on "ant" => :build
  depends_on "lzo"
  depends_on "openjdk@17"

  on_linux do
    on_arm do
      # Added automake as a build dependency to update config files for ARM support.
      depends_on "automake" => :build
    end
  end

  resource "hadoop-lzo" do
    url "https://github.com/cloudera/hadoop-lzo/archive/refs/tags/0.4.14.tar.gz"
    sha256 "aa8ddbb8b3f9e1c4b8cc3523486acdb7841cd97c002a9f2959c5b320c7bb0e6c"

    patch do
      url "https://raw.githubusercontent.com/Homebrew/homebrew-core/1cf441a0/Patches/hbase/build.xml.patch"
      sha256 "d1d65330a4367db3e17ee4f4045641b335ed42449d9e6e42cc687e2a2e3fa5bc"
    end

    # Fix -flat_namespace being used on Big Sur and later.
    patch do
      url "https://raw.githubusercontent.com/Homebrew/homebrew-core/1cf441a0/Patches/libtool/configure-pre-0.4.2.418-big_sur.diff"
      sha256 "83af02f2aa2b746bb7225872cab29a253264be49db0ecebb12f841562d9a2923"
      directory "src/native"
    end
  end

  def install
    java_home = Language::Java.java_home("17")
    rm(Dir["bin/*.cmd", "conf/*.cmd"])
    libexec.install %w[bin conf lib hbase-webapps]

    # Some binaries have really generic names (like `test`) and most seem to be
    # too special-purpose to be permanently available via PATH.
    %w[hbase start-hbase.sh stop-hbase.sh].each do |script|
      (bin/script).write_env_script libexec/"bin"/script, Language::Java.overridable_java_home_env("17")
    end

    resource("hadoop-lzo").stage do
      if OS.linux? && Hardware::CPU.arm?
        # Workaround for ancient config files not recognizing aarch64 macos.
        automake_dir = Formula["automake"].share/"automake-#{Formula["automake"].version.major_minor}"
        %w[config.guess config.sub].each { |fn| cp automake_dir/fn, "src/native/config/#{fn}" }
      end

      # Help configure to find liblzo on Linux.
      unless OS.mac?
        inreplace "src/native/configure",
        "#define HADOOP_LZO_LIBRARY ${ac_cv_libname_lzo2}",
        "#define HADOOP_LZO_LIBRARY \"#{formula_opt_lib("lzo")/shared_library("liblzo2")}\""
      end

      # Fixed upstream: https://github.com/cloudera/hadoop-lzo/blob/HEAD/build.xml#L235
      ENV["CLASSPATH"] = Dir["#{libexec}/lib/hadoop-common-*.jar"].first
      # Workaround for Xcode 14.3.
      ENV.append_to_cflags "-m64" if Hardware::CPU.intel?
      ENV.append_to_cflags "-Wno-implicit-function-declaration"
      ENV["CPPFLAGS"] = "-I#{Formula["openjdk@17"].include}"

      system "ant", "compile-native", "tar"
      (libexec/"lib").install Dir["build/hadoop-lzo-*/hadoop-lzo-*.jar"]
      (libexec/"lib/native").install Dir["build/hadoop-lzo-*/lib/native/*"]
    end

    inreplace libexec/"conf/hbase-env.sh" do |s|
      # upstream bugs for ipv6 incompatibility:
      # https://issues.apache.org/jira/browse/HADOOP-8568
      # https://issues.apache.org/jira/browse/HADOOP-3619
      s.gsub!(/^# export HBASE_OPTS$/,
              "export HBASE_OPTS=\"-Djava.net.preferIPv4Stack=true\"")
      s.gsub!(/^# export JAVA_HOME=.*/,
              "export JAVA_HOME=\"${JAVA_HOME:-#{java_home}}\"")

      # Default `$HBASE_HOME/logs` is unsuitable as it would cause writes to the
      # formula's prefix. Provide a better default but still allow override.
      s.gsub!(/^# export HBASE_LOG_DIR=.*$/,
              "export HBASE_LOG_DIR=\"${HBASE_LOG_DIR:-#{var}/log/hbase}\"")
    end

    # Interface name is lo on Linux, not lo0.
    loopback = OS.mac? ? "lo0" : "lo"
    # makes hbase usable out of the box
    # upstream has been provided this patch
    # https://issues.apache.org/jira/browse/HBASE-15426
    inreplace "#{libexec}/conf/hbase-site.xml",
      /<configuration>/,
      <<~XML
        <configuration>
          <property>
            <name>hbase.rootdir</name>
            <value>file://#{var}/hbase</value>
          </property>
          <property>
            <name>hbase.zookeeper.property.clientPort</name>
            <value>2181</value>
          </property>
          <property>
            <name>hbase.zookeeper.property.dataDir</name>
            <value>#{var}/zookeeper</value>
          </property>
          <property>
            <name>hbase.zookeeper.dns.interface</name>
            <value>#{loopback}</value>
          </property>
          <property>
            <name>hbase.regionserver.dns.interface</name>
            <value>#{loopback}</value>
          </property>
          <property>
            <name>hbase.master.dns.interface</name>
            <value>#{loopback}</value>
          </property>
      XML

    (var/"log/hbase").mkpath
    (var/"run/hbase").mkpath
  end

  service do
    run [opt_bin/"hbase", "--config", opt_libexec/"conf", "master", "start"]
    keep_alive true
    working_dir HOMEBREW_PREFIX
    log_path var/"hbase/hbase.log"
    error_log_path var/"hbase/hbase.err"
    environment_variables HBASE_HOME:              opt_libexec,
                          HBASE_IDENT_STRING:      "root",
                          HBASE_LOG_DIR:           var/"hbase",
                          HBASE_LOG_PREFIX:        "hbase-root-master",
                          HBASE_LOGFILE:           "hbase-root-master.log",
                          HBASE_MASTER_OPTS:       " -XX:PermSize=128m -XX:MaxPermSize=128m",
                          HBASE_NICENESS:          "0",
                          HBASE_PID_DIR:           var/"run/hbase",
                          HBASE_REGIONSERVER_OPTS: " -XX:PermSize=128m -XX:MaxPermSize=128m",
                          HBASE_ROOT_LOGGER:       "INFO,RFA",
                          HBASE_SECURITY_LOGGER:   "INFO,RFAS"
  end

  test do
    port = free_port
    assert_match "HBase #{version}", shell_output("#{bin}/hbase version 2>&1")

    cp_r (libexec/"conf"), testpath
    inreplace (testpath/"conf/hbase-site.xml") do |s|
      s.gsub!(/(hbase.rootdir.*)\n.*/, "\\1\n<value>file://#{testpath}/hbase</value>")
      s.gsub!(/(hbase.zookeeper.property.dataDir.*)\n.*/, "\\1\n<value>#{testpath}/zookeeper</value>")
      s.gsub!(/(hbase.zookeeper.property.clientPort.*)\n.*/, "\\1\n<value>#{port}</value>")
    end

    ENV["HBASE_LOG_DIR"]  = testpath/"logs"
    ENV["HBASE_CONF_DIR"] = testpath/"conf"
    ENV["HBASE_PID_DIR"]  = testpath/"pid"

    system bin/"start-hbase.sh"
    begin
      sleep 15
      TCPSocket.open("127.0.0.1", port) do |sock|
        sock.puts("stats")
        assert_match "Zookeeper", sock.gets
      ensure
        sock.close
      end
    ensure
      system bin/"stop-hbase.sh"
    end
  end
end
