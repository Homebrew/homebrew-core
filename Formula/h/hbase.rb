class Hbase < Formula
  desc "Hadoop database: a distributed, scalable, big data store"
  homepage "https://hbase.apache.org"
  url "https://www.apache.org/dyn/closer.lua?path=hbase/2.5.8/hbase-2.5.8-bin.tar.gz"
  mirror "https://archive.apache.org/dist/hbase/2.5.8/hbase-2.5.8-bin.tar.gz"
  sha256 "591d960f06986f958bd9ff592f11987b0b292661288cb42334b6135578c4c214"
  # We bundle hadoop-lzo which is GPL-3.0-or-later
  license all_of: ["Apache-2.0", "GPL-3.0-or-later"]

  bottle do
    sha256 arm64_sonoma:   "955ce25470c45d69f45c89b76a20d6f0fec9c7221f058abb824460b27dd762e2"
    sha256 arm64_ventura:  "b8c6dcb1266721bb857ebd0936ef343ea8d7804a8757079bbbea4e1a5dee581f"
    sha256 arm64_monterey: "2711da14d95814a3f64d0998b22a23793c58bffe2805d32aeb8ba5db322a16c7"
    sha256 sonoma:         "895bfa680767a495e9d304b2d1c7b98f703b279e76b3ef76b1ab6a85448f031a"
    sha256 ventura:        "5c07b5c543ec848424e0c443f432ca3858fdc4b4ef9847510fd772f42fe366ee"
    sha256 monterey:       "3335f3a5129300e59c71b553e053840c7d76f5a8cba78808aa69d32bf158e219"
    sha256 x86_64_linux:   "294f75e679376c0f2fa3bb185a965ecbc1702dd7fa9989f889ba0e66193e5ca1"
  end

  depends_on "ant" => :build
  depends_on "lzo"
  depends_on "openjdk@11"

  uses_from_macos "netcat" => :test

  resource "hadoop-lzo" do
    url "https://github.com/cloudera/hadoop-lzo/archive/refs/tags/0.4.14.tar.gz"
    sha256 "aa8ddbb8b3f9e1c4b8cc3523486acdb7841cd97c002a9f2959c5b320c7bb0e6c"

    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/b89da3afad84bbf69deed0611e5dddaaa5d39325/hbase/build.xml.patch"
      sha256 "d1d65330a4367db3e17ee4f4045641b335ed42449d9e6e42cc687e2a2e3fa5bc"
    end

    # Fix -flat_namespace being used on Big Sur and later.
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-pre-0.4.2.418-big_sur.diff"
      sha256 "83af02f2aa2b746bb7225872cab29a253264be49db0ecebb12f841562d9a2923"
      directory "src/native"
    end
  end

  def install
    java_home = Language::Java.java_home("11")
    rm_f Dir["bin/*.cmd", "conf/*.cmd"]
    libexec.install %w[bin conf lib hbase-webapps]

    # Some binaries have really generic names (like `test`) and most seem to be
    # too special-purpose to be permanently available via PATH.
    %w[hbase start-hbase.sh stop-hbase.sh].each do |script|
      (bin/script).write_env_script libexec/"bin"/script, Language::Java.overridable_java_home_env("11")
    end

    resource("hadoop-lzo").stage do
      # Help configure to find liblzo on Linux.
      unless OS.mac?
        inreplace "src/native/configure",
        "#define HADOOP_LZO_LIBRARY ${ac_cv_libname_lzo2}",
        "#define HADOOP_LZO_LIBRARY \"#{Formula["lzo"].opt_lib/shared_library("liblzo2")}\""
      end

      # Fixed upstream: https://github.com/cloudera/hadoop-lzo/blob/HEAD/build.xml#L235
      ENV["CLASSPATH"] = Dir["#{libexec}/lib/hadoop-common-*.jar"].first
      # Workaround for Xcode 14.3.
      ENV["CFLAGS"] = "-m64 -Wno-implicit-function-declaration"
      ENV["CXXFLAGS"] = "-m64"
      ENV["CPPFLAGS"] = "-I#{Formula["openjdk@11"].include}"
      system "ant", "compile-native", "tar"
      (libexec/"lib").install Dir["build/hadoop-lzo-*/hadoop-lzo-*.jar"]
      (libexec/"lib/native").install Dir["build/hadoop-lzo-*/lib/native/*"]
    end

    inreplace libexec/"conf/hbase-env.sh" do |s|
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

    # Interface name is lo on Linux, not lo0.
    loopback = OS.mac? ? "lo0" : "lo"
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
    sleep 15
    begin
      assert_match "Zookeeper", pipe_output("nc 127.0.0.1 #{port} 2>&1", "stats")
    ensure
      system "#{bin}/stop-hbase.sh"
    end
  end
end
