class Druid < Formula
  desc "High-performance, column-oriented, distributed data store"
  homepage "https://druid.apache.org/"
  url "https://dlcdn.apache.org/druid/26.0.0/apache-druid-26.0.0-bin.tar.gz"
  mirror "https://archive.apache.org/dist/druid/26.0.0/apache-druid-26.0.0-bin.tar.gz"
  sha256 "535424284c141ce9736e3a4c198fc367707b9471a4c739d13d1cb8b142d945b0"
  license "Apache-2.0"

  livecheck do
    url "https://druid.apache.org/downloads.html"
    regex(/href=.*?druid[._-]v?(\d+(?:\.\d+)+)-bin\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "82669b9daf370814051d8f059a45c2381f41eef304b198bdf8f3032f95f4cc20"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "82669b9daf370814051d8f059a45c2381f41eef304b198bdf8f3032f95f4cc20"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "82669b9daf370814051d8f059a45c2381f41eef304b198bdf8f3032f95f4cc20"
    sha256 cellar: :any_skip_relocation, ventura:        "856b76b85b577ba23439471ecd3cca1bf6c791f7b01a8c26ebc54cd561a57c24"
    sha256 cellar: :any_skip_relocation, monterey:       "856b76b85b577ba23439471ecd3cca1bf6c791f7b01a8c26ebc54cd561a57c24"
    sha256 cellar: :any_skip_relocation, big_sur:        "856b76b85b577ba23439471ecd3cca1bf6c791f7b01a8c26ebc54cd561a57c24"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a7b7eb4c77c049ca32abcce61cb911c4498f8beb661752a53e4b906c36cf4734"
  end

  depends_on "zookeeper" => :test
  depends_on "openjdk@11"

  resource "mysql-connector-java" do
    url "https://search.maven.org/remotecontent?filepath=mysql/mysql-connector-java/5.1.49/mysql-connector-java-5.1.49.jar"
    sha256 "5bba9ff50e5e637a0996a730619dee19ccae274883a4d28c890d945252bb0e12"
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
      s.gsub! ":=${WHEREAMI}/log", ":=#{var}/druid/log"
      s.gsub! ":=var/druid/pids", ":=#{var}/druid/pids"
    end

    resource("mysql-connector-java").stage do
      (libexec/"extensions/mysql-metadata-storage").install Dir["*"]
    end

    bin.install Dir["#{libexec}/bin/*.sh"]
    bin.env_script_all_files libexec/"bin", Language::Java.overridable_java_home_env("11")

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
