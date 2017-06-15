class Druid < Formula
  desc "High-performance, column-oriented, distributed data store"
  homepage "http://druid.io"
  url "http://static.druid.io/artifacts/releases/druid-0.10.0-bin.tar.gz"
  sha256 "5c734587528287d35979f0da7ee50fa568322e35296309a16658414c5bb6fae4"

  bottle :unneeded

  option "with-mysql", "Build with mysql-metadata-storage plugin"

  depends_on "zookeeper"
  depends_on :java => "1.8+"

  resource "mysql-metadata-storage" do
    url "http://static.druid.io/artifacts/releases/mysql-metadata-storage-0.10.0.tar.gz"
    sha256 "80c15f9614cadbd0f69c21a27d03af8b4533a59d793b0eb0283bc46565e9e1e6"
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
      s.gsub! "nohup java", "nohup java -Ddruid.extensions.directory=\"#{libexec}/extensions\""
      s.gsub! ":=lib", ":=#{libexec}/lib"
      s.gsub! ":=conf/druid", ":=#{libexec}/conf/druid"
      s.gsub! ":=log", ":=#{var}/druid/log"
      s.gsub! ":=var/druid/pids", ":=#{var}/druid/pids"
    end

    if build.with? "mysql"
      resource("mysql-metadata-storage").stage do
        (libexec/"extensions/mysql-metadata-storage").install Dir["*"]
      end
    else
      inreplace libexec/"conf/druid/_common/common.runtime.properties",
                ", \"mysql-metadata-storage\"", ""
    end

    Pathname.glob("#{libexec}/bin/*.sh") do |file|
      bin.install_symlink file => "druid-#{file.basename}"
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
    ENV["DRUID_CONF_DIR"] = libexec/"conf-quickstart/druid"
    ENV["DRUID_LOG_DIR"] = testpath
    ENV["DRUID_PID_DIR"] = testpath

    begin
      pid = fork { exec bin/"druid-broker.sh", "start" }
      sleep 30
      output = shell_output("curl -s http://localhost:8082/status")
      assert_match /version/m, output
    ensure
      system bin/"druid-broker.sh", "stop"
      Process.wait pid
    end
  end
end
