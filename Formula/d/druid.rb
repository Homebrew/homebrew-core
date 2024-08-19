class Druid < Formula
  desc "High-performance, column-oriented, distributed data store"
  homepage "https://druid.apache.org/"
  url "https://dlcdn.apache.org/druid/30.0.0/apache-druid-30.0.0-bin.tar.gz"
  mirror "https://archive.apache.org/dist/druid/30.0.0/apache-druid-30.0.0-bin.tar.gz"
  sha256 "991628ad590dcccf782cfe771bbf1e5b6d0de54b2f30fecbbf8ac0cac98fc17c"
  license "Apache-2.0"

  livecheck do
    url "https://druid.apache.org/downloads/"
    regex(/href=.*?druid[._-]v?(\d+(?:\.\d+)+)-bin\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ce41d8a91d03ea17758ff0a6863445d2aa03a7b0b7ae8dbc6d27e7424ff6fccc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ce41d8a91d03ea17758ff0a6863445d2aa03a7b0b7ae8dbc6d27e7424ff6fccc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ce41d8a91d03ea17758ff0a6863445d2aa03a7b0b7ae8dbc6d27e7424ff6fccc"
    sha256 cellar: :any_skip_relocation, sonoma:         "0a7868c902c4f25f309b4492d78d1b17b07c4de23b80c34d7ec886c88583be70"
    sha256 cellar: :any_skip_relocation, ventura:        "0a7868c902c4f25f309b4492d78d1b17b07c4de23b80c34d7ec886c88583be70"
    sha256 cellar: :any_skip_relocation, monterey:       "0a7868c902c4f25f309b4492d78d1b17b07c4de23b80c34d7ec886c88583be70"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "77dfff322944b9b0c613078eff65dc3b59260af309ba990e761a974fe3c329e6"
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
