class Hbase < Formula
  desc "Hadoop database: a distributed, scalable, big data store"
  homepage "https://hbase.apache.org"
  url "https://www.apache.org/dyn/closer.lua?path=hbase/2.6.6/hbase-2.6.6-bin.tar.gz"
  mirror "https://archive.apache.org/dist/hbase/2.6.6/hbase-2.6.6-bin.tar.gz"
  sha256 "cbcfbfed6411cf898961133c228dcdb4beeb155a611e503ccb212e6f08abec00"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "16c927027587377823e7cb562023adaee6421874fb6e131e22290e6f3d8f42f3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "16c927027587377823e7cb562023adaee6421874fb6e131e22290e6f3d8f42f3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "16c927027587377823e7cb562023adaee6421874fb6e131e22290e6f3d8f42f3"
    sha256 cellar: :any_skip_relocation, sonoma:        "5e45a3415796d599b63537f18a32bf2e55a104ca4af8cdbcf5c8e904c820647d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3fa790a5b8c6e12b4c882a392dcdcf49eba5ab4940f0ffc40b03e11f78bd2470"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3fa790a5b8c6e12b4c882a392dcdcf49eba5ab4940f0ffc40b03e11f78bd2470"
  end

  depends_on "ant" => :build
  depends_on "openjdk@17"

  on_linux do
    on_arm do
      # Added automake as a build dependency to update config files for ARM support.
      depends_on "automake" => :build
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
