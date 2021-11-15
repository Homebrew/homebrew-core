class Druid < Formula
  desc "High-performance, column-oriented, distributed data store"
  homepage "https://druid.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=druid/0.22.0/apache-druid-0.22.0-bin.tar.gz"
  mirror "https://archive.apache.org/dist/druid/0.22.0/apache-druid-0.22.0-bin.tar.gz"
  sha256 "5ce9ba185361a20694fd107ffc818fb42d13a44911d010739227b5c62a8fc1da"
  license "Apache-2.0"

  livecheck do
    url "https://druid.apache.org/downloads.html"
    regex(/href=.*?druid[._-]v?(\d+(?:\.\d+)+)-bin\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "4ad3956fa92f96ecc67e3dd88cb641ee1a697f45c8e54df5c7d802eded4b479a"
  end

  depends_on "zookeeper" => :test
  depends_on arch: :x86_64
  depends_on "openjdk@8"

  resource "mysql-connector-java" do
    url "https://search.maven.org/remotecontent?filepath=mysql/mysql-connector-java/5.1.48/mysql-connector-java-5.1.48.jar"
    sha256 "56e26caaa3821f5ae4af44f9c74f66cf8b84ea01516ad3803cbb0e9049b6eca8"
  end

  def install
    libexec.install Dir["*"]

    %w[
      broker.sh
      coordinator.sh
      historical.sh
      middleManager.sh
      overlord.sh
    ].each do |sh|
      inreplace libexec/"bin/#{sh}", "./bin/node.sh", libexec/"bin/node.sh"
    end

    inreplace libexec/"bin/node.sh" do |s|
      s.gsub! "nohup $JAVA", "nohup $JAVA -Ddruid.extensions.directory=\"#{libexec}/extensions\""
      s.gsub! ":=lib", ":=#{libexec}/lib"
      s.gsub! ":=conf/druid", ":=#{libexec}/conf/druid"
      s.gsub! ":=log", ":=#{var}/druid/log"
      s.gsub! ":=var/druid/pids", ":=#{var}/druid/pids"
    end

    resource("mysql-connector-java").stage do
      (libexec/"extensions/mysql-metadata-storage").install Dir["*"]
    end

    bin.install Dir["#{libexec}/bin/*.sh"]
    bin.env_script_all_files libexec/"bin", Language::Java.overridable_java_home_env("1.8")

    Pathname.glob("#{bin}/*.sh") do |file|
      mv file, bin/"druid-#{file.basename}"
    end
  end

  def post_install
    %w[
      druid/hadoop-tmp
      druid/indexing-logs
      druid/log
      druid/pids
      druid/segments
      druid/task
    ].each do |dir|
      (var/dir).mkpath
    end
  end

  test do
    ENV["DRUID_CONF_DIR"] = libexec/"conf/druid/single-server/nano-quickstart"
    ENV["DRUID_LOG_DIR"] = testpath
    ENV["DRUID_PID_DIR"] = testpath
    ENV["ZOO_LOG_DIR"] = testpath

    system Formula["zookeeper"].opt_bin/"zkServer", "start"
    begin
      pid = fork { exec bin/"druid-broker.sh", "start" }
      sleep 40
      output = shell_output("curl -s http://localhost:8082/status")
      assert_match "version", output
    ensure
      system bin/"druid-broker.sh", "stop"
      # force zookeeper stop since it is sometimes still alive after druid-broker.sh finishes
      system Formula["zookeeper"].opt_bin/"zkServer", "stop"
      Process.wait pid
    end
  end
end
