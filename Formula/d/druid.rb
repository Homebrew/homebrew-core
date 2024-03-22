class Druid < Formula
  desc "High-performance, column-oriented, distributed data store"
  homepage "https://druid.apache.org/"
  url "https://dlcdn.apache.org/druid/29.0.0/apache-druid-29.0.0-bin.tar.gz"
  mirror "https://archive.apache.org/dist/druid/29.0.0/apache-druid-29.0.0-bin.tar.gz"
  sha256 "29afdca0c5985c38cfd7c860c3026afb1cd23bbb4beff5ed21945c7a4a57ea0e"
  license "Apache-2.0"

  livecheck do
    url "https://druid.apache.org/downloads/"
    regex(/href=.*?druid[._-]v?(\d+(?:\.\d+)+)-bin\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "20b51e7ad02db55ddd885b8c71af320a16910066bed4b78d71217bfd143bb955"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "20b51e7ad02db55ddd885b8c71af320a16910066bed4b78d71217bfd143bb955"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "20b51e7ad02db55ddd885b8c71af320a16910066bed4b78d71217bfd143bb955"
    sha256 cellar: :any_skip_relocation, sonoma:         "19636521a22b6df0176d92b496e34c48085a78377faddb71c0d359580de69faa"
    sha256 cellar: :any_skip_relocation, ventura:        "19636521a22b6df0176d92b496e34c48085a78377faddb71c0d359580de69faa"
    sha256 cellar: :any_skip_relocation, monterey:       "19636521a22b6df0176d92b496e34c48085a78377faddb71c0d359580de69faa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "20b51e7ad02db55ddd885b8c71af320a16910066bed4b78d71217bfd143bb955"
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
      s.gsub! "nohup \"$BIN_DIR/run-java\"",
              "nohup \"$BIN_DIR/run-java\" -Ddruid.extensions.directory=\"#{libexec}/extensions\""
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
