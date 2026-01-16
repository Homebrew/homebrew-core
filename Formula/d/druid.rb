class Druid < Formula
  desc "High-performance, column-oriented, distributed data store"
  homepage "https://druid.apache.org/"
  url "https://dlcdn.apache.org/druid/35.0.1/apache-druid-35.0.1-bin.tar.gz"
  mirror "https://archive.apache.org/dist/druid/35.0.1/apache-druid-35.0.1-bin.tar.gz"
  sha256 "2df51edc0d97d4f0019088131d62e6409f37eac1dd7178b461ff13fb5e5448cc"
  license "Apache-2.0"

  livecheck do
    url "https://druid.apache.org/downloads/"
    regex(/href=.*?druid[._-]v?(\d+(?:\.\d+)+)-bin\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "526dbda2ff468e86b039ebe5b44cbdc7724d346e40ac6aa3b4cb9293e621fc91"
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

    # Reduce bottle and install size by hardlinking duplicate JARs
    # TODO: Move logic to brew DSL
    libexec.glob("**/*.jar").each_with_object({}) do |jar, jars_hash|
      next if !jar.file? || jar.symlink?

      found_jar = jars_hash[jar.basename.to_s]
      if found_jar.nil?
        jars_hash[jar.basename.to_s] = jar
      elsif found_jar.stat.ino != jar.stat.ino && compare_file(found_jar, jar)
        rm(jar)
        jar.make_link(found_jar)
      end
    end
  end

  test do
    ENV["DRUID_CONF_DIR"] = libexec/"conf/druid/single-server/nano-quickstart"
    ENV["DRUID_LOG_DIR"] = testpath
    ENV["DRUID_PID_DIR"] = testpath
    ENV["ZOO_LOG_DIR"] = testpath

    system Formula["zookeeper"].opt_bin/"zkServer", "start"
    begin
      pid = spawn bin/"druid-broker.sh", "start"
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
