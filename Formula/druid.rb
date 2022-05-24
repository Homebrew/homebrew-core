class Druid < Formula
  desc "High-performance, column-oriented, distributed data store"
  homepage "https://druid.apache.org/"
  url "https://dlcdn.apache.org/druid/0.22.1/apache-druid-0.22.1-bin.tar.gz"
  mirror "https://archive.apache.org/dist/druid/0.22.1/apache-druid-0.22.1-bin.tar.gz"
  sha256 "bd83d8f8235c74d47577468d65f96d302e6918b017e6338cfbb040df9157143c"
  license "Apache-2.0"

  livecheck do
    url "https://druid.apache.org/downloads.html"
    regex(/href=.*?druid[._-]v?(\d+(?:\.\d+)+)-bin\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:      "ad7e134eb7daa12f3175bc93f269c471ce7f636d86118d7c0cfaebe8c8dc2450"
    sha256 cellar: :any_skip_relocation, catalina:     "ad7e134eb7daa12f3175bc93f269c471ce7f636d86118d7c0cfaebe8c8dc2450"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "525049785863e472e223ea3d141178598cbb117f242d8ea0b5ab4864175d71f7"
  end

  depends_on "zookeeper" => :test
  depends_on "openjdk@8"

  resource "mysql-connector-java" do
    url "https://search.maven.org/remotecontent?filepath=mysql/mysql-connector-java/5.1.49/mysql-connector-java-5.1.49.jar"
    sha256 "5bba9ff50e5e637a0996a730619dee19ccae274883a4d28c890d945252bb0e12"
  end

  # Fixes: node.sh: source: not found. Remove with next release
  # https://github.com/apache/druid/pull/12014
  patch :DATA

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

__END__
diff -Naur apache-druid-0.22.0-old/bin/node.sh apache-druid-0.22.0/bin/node.sh
--- apache-druid-0.22.0-old/bin/node.sh	2021-11-30 21:39:18.000000000 +0100
+++ apache-druid-0.22.0/bin/node.sh	2021-11-30 21:40:08.000000000 +0100
@@ -41,7 +41,7 @@
 PID_DIR="${DRUID_PID_DIR:=var/druid/pids}"
 WHEREAMI="$(dirname "$0")"
 WHEREAMI="$(cd "$WHEREAMI" && pwd)"
-JAVA_BIN_DIR="$(source "$WHEREAMI"/java-util && get_java_bin_dir)"
+JAVA_BIN_DIR="$(. /"$WHEREAMI"/java-util && get_java_bin_dir)"

 pid=$PID_DIR/$nodeType.pid
