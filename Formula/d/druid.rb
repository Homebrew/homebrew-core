class Druid < Formula
  desc "High-performance, column-oriented, distributed data store"
  homepage "https://druid.apache.org/"
  url "https://dlcdn.apache.org/druid/27.0.0/apache-druid-27.0.0-bin.tar.gz"
  mirror "https://archive.apache.org/dist/druid/27.0.0/apache-druid-27.0.0-bin.tar.gz"
  sha256 "c6f1a3bb207ff82a93357959d9504cf639bd58623d08a765cdfda71c76f5e729"
  license "Apache-2.0"

  livecheck do
    url "https://druid.apache.org/downloads/"
    regex(/href=.*?druid[._-]v?(\d+(?:\.\d+)+)-bin\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "572489695d59f1be0bc9cc76c03ca580ec4f8440c1bc27a800440ea8d57c47d8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "572489695d59f1be0bc9cc76c03ca580ec4f8440c1bc27a800440ea8d57c47d8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "572489695d59f1be0bc9cc76c03ca580ec4f8440c1bc27a800440ea8d57c47d8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "572489695d59f1be0bc9cc76c03ca580ec4f8440c1bc27a800440ea8d57c47d8"
    sha256 cellar: :any_skip_relocation, sonoma:         "255d797399e6b691c2f01001ee60d5879a0d1cb2549958219cda1c2ffebb98ae"
    sha256 cellar: :any_skip_relocation, ventura:        "255d797399e6b691c2f01001ee60d5879a0d1cb2549958219cda1c2ffebb98ae"
    sha256 cellar: :any_skip_relocation, monterey:       "255d797399e6b691c2f01001ee60d5879a0d1cb2549958219cda1c2ffebb98ae"
    sha256 cellar: :any_skip_relocation, big_sur:        "255d797399e6b691c2f01001ee60d5879a0d1cb2549958219cda1c2ffebb98ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a9f05770b4c450344a5c38223cde2cebe28f78d6c1e09b13d1ed7c90d98a43a2"
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
