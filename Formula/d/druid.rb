class Druid < Formula
  desc "High-performance, column-oriented, distributed data store"
  homepage "https://druid.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=druid/39.0.0/apache-druid-39.0.0-bin.tar.gz"
  mirror "https://archive.apache.org/dist/druid/39.0.0/apache-druid-39.0.0-bin.tar.gz"
  sha256 "219fa33ea9eaf2f8e745de8f5bfba3e630152cb78ff763f8690e935edef90516"
  license "Apache-2.0"

  livecheck do
    url "https://druid.apache.org/downloads/"
    regex(/href=.*?druid[._-]v?(\d+(?:\.\d+)+)-bin\.t/i)
  end

  bottle do
    manifest_sha256 "01ac8377aff08f5e8555bbdd244476dc5387cf3ff5d0cbf84746b083168d629f"
    sha256 cellar: :any_skip_relocation, all: "72ad52abb73c276b34fc9cbbfa78d3e7361eba572f60a4ddc6b5d17995ab3861"
  end

  depends_on "zookeeper" => :test
  depends_on "openjdk"

  # check https://github.com/apache/druid/blob/master/docs/development/extensions-core/mysql.md#install-mysql-connectorj
  # for mysql-connector-java version compatibility
  # upstream report on updating mysql-connector-java, https://github.com/apache/druid/issues/18999
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
    bin.env_script_all_files libexec/"bin", Language::Java.overridable_java_home_env

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

    system formula_opt_bin("zookeeper")/"zkServer", "start"
    begin
      pid = spawn bin/"druid-broker.sh", "start"
      sleep 40
    ensure
      system bin/"druid-broker.sh", "stop"
      # force zookeeper stop since it is sometimes still alive after druid-broker.sh finishes
      system formula_opt_bin("zookeeper")/"zkServer", "stop"
      Process.wait pid
    end

    assert_match "All servers have been synced successfully at least once.", (testpath/"broker.log").read
  end
end
