class Druid < Formula
  desc "High-performance, column-oriented, distributed data store"
  homepage "https://druid.apache.org/"
  url "https://dlcdn.apache.org/druid/35.0.0/apache-druid-35.0.0-bin.tar.gz"
  mirror "https://archive.apache.org/dist/druid/35.0.0/apache-druid-35.0.0-bin.tar.gz"
  sha256 "d4c2d2cf5f37e7741ceb0683083ce62a266a460436fbf3a4a02185395df3c361"
  license "Apache-2.0"

  livecheck do
    url "https://druid.apache.org/downloads/"
    regex(/href=.*?druid[._-]v?(\d+(?:\.\d+)+)-bin\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "27e8894f048cfcecdb884e9122a67720085959296bf9ed69b1bb9db325613a43"
  end

  depends_on "zookeeper" => :test
  depends_on "openjdk@17" # JDK 21 issue: https://github.com/apache/druid/issues/17429

  # check https://github.com/apache/druid/blob/master/docs/development/extensions-core/mysql.md#install-mysql-connectorj
  # for mysql-connector-java version compatibility
  resource "mysql-connector-java" do
    url "https://search.maven.org/remotecontent?filepath=com/mysql/mysql-connector-j/8.2.0/mysql-connector-j-8.2.0.jar"
    sha256 "06f14fbd664d0e382347489e66495ca27ab7e6c2e1d9969a496931736197465f"
  end

  def install
    rm_r "quickstart/tutorial"
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
    bin.env_script_all_files libexec/"bin", Language::Java.overridable_java_home_env("17")

    Pathname.glob("#{bin}/*.sh") do |file|
      mv file, bin/"druid-#{file.basename}"
    end

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
    ensure
      system bin/"druid-broker.sh", "stop"
      # force zookeeper stop since it is sometimes still alive after druid-broker.sh finishes
      system Formula["zookeeper"].opt_bin/"zkServer", "stop"
      Process.wait pid
    end

    assert_match "All servers have been synced successfully at least once.", (testpath/"broker.log").read
  end
end
