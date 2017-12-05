class Druid < Formula
  desc "High-performance, column-oriented, distributed data store"
  homepage "http://druid.io"
  url "http://static.druid.io/artifacts/releases/druid-0.11.0-bin.tar.gz"
  sha256 "d50218d11f97612acc1447914e113f1869997640de586daabd85828440c4c546"

  bottle :unneeded

  option "with-mysql", "Build with mysql-metadata-storage plugin"

  depends_on "zookeeper"
  depends_on :java => "1.8"

  resource "mysql-metadata-storage" do
    url "http://static.druid.io/artifacts/releases/mysql-metadata-storage-0.11.0.tar.gz"
    sha256 "13fd978cdcfa7f9bac715642f37ddc8bdaf572ce05a2326c455ab8284d457141"
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

    bin.install Dir["#{libexec}/bin/*.sh"]
    bin.env_script_all_files(libexec/"bin", Language::Java.java_home_env("1.8"))

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
