class Hbase < Formula
  desc "Hadoop database: a distributed, scalable, big data store"
  homepage "https://hbase.apache.org"
  url "https://www.apache.org/dyn/closer.lua?path=hbase/2.4.5/hbase-2.4.5-bin.tar.gz"
  mirror "https://archive.apache.org/dist/hbase/2.4.5/hbase-2.4.5-bin.tar.gz"
  sha256 "7fb61e0ab05ec8b6aaeaa24e2037ea8e5753ce7e9a36c99796f102a263bf7ffa"
  license "Apache-2.0"

  bottle do
    sha256 arm64_big_sur: "7a0178466daa5ac2956269e16b2ef14b47b8ef6acae03f9926ae78697cd562ec"
    sha256 big_sur:       "88c89d28ecdecf7787a1f89450a54d9446cd412fc58d8a8459cc554ccda5893b"
    sha256 catalina:      "a292c7c6a3cdaea1f58a721c6dbc6dff80fc9cb0b9882dc7136da028c80aa3d1"
    sha256 mojave:        "619e320c7a40c49bdd24f5b319d8dae72c7afffbfca0841872bb12f123865d0e"
  end

  depends_on "ant" => :build
  depends_on "lzo"
  depends_on "openjdk@11"

  resource "hadoop-lzo" do
    url "https://github.com/cloudera/hadoop-lzo/archive/0.4.14.tar.gz"
    sha256 "aa8ddbb8b3f9e1c4b8cc3523486acdb7841cd97c002a9f2959c5b320c7bb0e6c"

    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/b89da3afad84bbf69deed0611e5dddaaa5d39325/hbase/build.xml.patch"
      sha256 "d1d65330a4367db3e17ee4f4045641b335ed42449d9e6e42cc687e2a2e3fa5bc"
    end
  end

  def install
    java_home = Formula["openjdk@11"].opt_prefix
    rm_f Dir["bin/*.cmd", "conf/*.cmd"]
    libexec.install %w[bin conf lib hbase-webapps]

    # Some binaries have really generic names (like `test`) and most seem to be
    # too special-purpose to be permanently available via PATH.
    %w[hbase start-hbase.sh stop-hbase.sh].each do |script|
      (bin/script).write_env_script "#{libexec}/bin/#{script}", JAVA_HOME: "${JAVA_HOME:-#{java_home}}"
    end

    resource("hadoop-lzo").stage do
      # Fixed upstream: https://github.com/cloudera/hadoop-lzo/blob/HEAD/build.xml#L235
      ENV["CLASSPATH"] = Dir["#{libexec}/lib/hadoop-common-*.jar"].first
      ENV["CFLAGS"] = "-m64"
      ENV["CXXFLAGS"] = "-m64"
      ENV["CPPFLAGS"] = "-I#{Formula["openjdk@11"].include}"
      system "ant", "compile-native", "tar"
      (libexec/"lib").install Dir["build/hadoop-lzo-*/hadoop-lzo-*.jar"]
      (libexec/"lib/native").install Dir["build/hadoop-lzo-*/lib/native/*"]
    end

    inreplace "#{libexec}/conf/hbase-env.sh" do |s|
      # upstream bugs for ipv6 incompatibility:
      # https://issues.apache.org/jira/browse/HADOOP-8568
      # https://issues.apache.org/jira/browse/HADOOP-3619
      s.gsub!(/^# export HBASE_OPTS$/,
              "export HBASE_OPTS=\"-Djava.net.preferIPv4Stack=true -XX:+UseConcMarkSweepGC\"")
      s.gsub!(/^# export JAVA_HOME=.*/,
              "export JAVA_HOME=\"${JAVA_HOME:-#{java_home}}\"")

      # Default `$HBASE_HOME/logs` is unsuitable as it would cause writes to the
      # formula's prefix. Provide a better default but still allow override.
      s.gsub!(/^# export HBASE_LOG_DIR=.*$/,
              "export HBASE_LOG_DIR=\"${HBASE_LOG_DIR:-#{var}/log/hbase}\"")
    end

    # makes hbase usable out of the box
    # upstream has been provided this patch
    # https://issues.apache.org/jira/browse/HBASE-15426
    inreplace "#{libexec}/conf/hbase-site.xml",
      /<configuration>/,
      <<~EOS
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
            <value>lo0</value>
          </property>
          <property>
            <name>hbase.regionserver.dns.interface</name>
            <value>lo0</value>
          </property>
          <property>
            <name>hbase.master.dns.interface</name>
            <value>lo0</value>
          </property>
      EOS
  end

  def post_install
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
                          HBASE_OPTS:              "-XX:+UseConcMarkSweepGC",
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

    system "#{bin}/start-hbase.sh"
    sleep 10
    begin
      assert_match "Zookeeper", pipe_output("nc 127.0.0.1 #{port} 2>&1", "stats")
    ensure
      system "#{bin}/stop-hbase.sh"
    end
  end
end
