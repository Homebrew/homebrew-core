class Druid < Formula
  desc "High-performance, column-oriented, distributed data store"
  homepage "https://druid.apache.org/"
  url "https://www.apache.org/dyn/closer.cgi?path=/incubator/druid/0.15.0-incubating/apache-druid-0.15.0-incubating-bin.tar.gz"
  sha256 "d0097be55216b3c9a7f954b134af70d4d643f63a4b514430df015b45400e7e89"

  bottle :unneeded

  depends_on :java => "1.8"
  depends_on "zookeeper"

  resource "mysql-metadata-storage" do
    url "http://static.druid.io/artifacts/releases/mysql-metadata-storage-0.12.3.tar.gz"
    sha256 "8ee27e3c7906abcd401cfd59072602bd1f83828b66397ae2cf2c3ff0e1860162"
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

    resource("mysql-metadata-storage").stage do
      (libexec/"extensions/mysql-metadata-storage").install Dir["*"]
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
