class Hbase < Formula
  desc "Hadoop database: a distributed, scalable, big data store"
  homepage "https://hbase.apache.org"
  url "https://www.apache.org/dyn/closer.lua?path=hbase/2.3.3/hbase-2.3.3-bin.tar.gz"
  mirror "https://archive.apache.org/dist/hbase/2.3.3/hbase-2.3.3-bin.tar.gz"
  sha256 "783fec0f1ca67cef53524a2e05f1744c84821454d1a69355e373acb09efeea06"
  license "Apache-2.0"

  livecheck do
    url :stable
  end

  bottle do
    sha256 "d59f469c0fc89b942be566b057e5243cbd19ac6229ec75f93245779474acd1ef" => :big_sur
    sha256 "a4f03f082e6691d459f0a7013178f058134d36836238b9f5a828988c08c1b1a2" => :arm64_big_sur
    sha256 "f703e3ddce84f7a365e55075d4a488971b7857f2b8c310005d0fa239728a3727" => :catalina
    sha256 "6f6a789f2bc0a72c81c7ae393438add0506e426365acf81045fea89be5778874" => :mojave
    sha256 "487a62bec9fa66f7303c4863587cfed140630a4b14510076d771f10f38f31f37" => :high_sierra
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
      s.gsub! /^# export HBASE_OPTS$/,
              "export HBASE_OPTS=\"-Djava.net.preferIPv4Stack=true -XX:+UseConcMarkSweepGC\""
      s.gsub! /^# export JAVA_HOME=.*/,
              "export JAVA_HOME=\"${JAVA_HOME:-#{java_home}}\""

      # Default `$HBASE_HOME/logs` is unsuitable as it would cause writes to the
      # formula's prefix. Provide a better default but still allow override.
      s.gsub! /^# export HBASE_LOG_DIR=.*$/,
              "export HBASE_LOG_DIR=\"${HBASE_LOG_DIR:-#{var}/log/hbase}\""
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

  plist_options manual: "#{HOMEBREW_PREFIX}/opt/hbase/bin/start-hbase.sh"

  def plist
    <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
      <dict>
        <key>KeepAlive</key>
        <true/>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>EnvironmentVariables</key>
        <dict>
         <key>HBASE_MASTER_OPTS</key><string> -XX:PermSize=128m -XX:MaxPermSize=128m</string>
         <key>HBASE_LOG_DIR</key><string>#{var}/hbase</string>
         <key>HBASE_HOME</key><string>#{opt_libexec}</string>
         <key>HBASE_SECURITY_LOGGER</key><string>INFO,RFAS</string>
         <key>HBASE_PID_DIR</key><string>#{var}/run/hbase</string>
         <key>HBASE_NICENESS</key><string>0</string>
         <key>HBASE_IDENT_STRING</key><string>root</string>
         <key>HBASE_REGIONSERVER_OPTS</key><string> -XX:PermSize=128m -XX:MaxPermSize=128m</string>
         <key>HBASE_OPTS</key><string>-XX:+UseConcMarkSweepGC</string>
         <key>HBASE_ROOT_LOGGER</key><string>INFO,RFA</string>
         <key>HBASE_LOG_PREFIX</key><string>hbase-root-master</string>
         <key>HBASE_LOGFILE</key><string>hbase-root-master.log</string>
        </dict>
        <key>ProgramArguments</key>
        <array>
          <string>#{opt_bin}/hbase</string>
          <string>--config</string>
          <string>#{opt_libexec}/conf</string>
          <string>master</string>
          <string>start</string>
        </array>
        <key>RunAtLoad</key>
        <true/>
        <key>WorkingDirectory</key>
        <string>#{HOMEBREW_PREFIX}</string>
        <key>StandardOutPath</key>
        <string>#{var}/hbase/hbase.log</string>
        <key>StandardErrorPath</key>
        <string>#{var}/hbase/hbase.err</string>
      </dict>
      </plist>
    EOS
  end

  test do
    port = free_port
    assert_match "HBase #{version}", shell_output("#{bin}/hbase version 2>&1")

    cp_r (libexec/"conf"), testpath
    inreplace (testpath/"conf/hbase-site.xml") do |s|
      s.gsub! /(hbase.rootdir.*)\n.*/, "\\1\n<value>file://#{testpath}/hbase</value>"
      s.gsub! /(hbase.zookeeper.property.dataDir.*)\n.*/, "\\1\n<value>#{testpath}/zookeeper</value>"
      s.gsub! /(hbase.zookeeper.property.clientPort.*)\n.*/, "\\1\n<value>#{port}</value>"
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
