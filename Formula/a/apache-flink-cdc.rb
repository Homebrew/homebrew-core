class ApacheFlinkCdc < Formula
  desc "Flink CDC is a streaming data integration tool"
  homepage "https://nightlies.apache.org/flink/flink-cdc-docs-stable"
  url "https://www.apache.org/dyn/mirrors/mirrors.cgi?action=download&filename=flink/flink-cdc-3.2.0/flink-cdc-3.2.0-bin.tar.gz"
  mirror "https://archive.apache.org/dist/flink/flink-cdc-3.2.0/flink-cdc-3.2.0-bin.tar.gz"
  sha256 "c3c9a4b78d7009a638ed088e0ec72ab5458e92e43ed179e8e2cf17341dbc8c56"
  license "Apache-2.0"
  head "https://github.com/apache/flink-cdc.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "34082266af28ae4ebf24efb1ad273ffcf1568a5fd24011ba81f70252f5fdea99"
  end

  depends_on "apache-flink" => :test

  resource "mysql-connector" do
    url "https://search.maven.org/remotecontent?filepath=org/apache/flink/flink-cdc-pipeline-connector-mysql/3.2.0/flink-cdc-pipeline-connector-mysql-3.2.0.jar"
    sha256 "042e368fb9b82452fd160f749bc167225d8d784f077bfaefc1b8219312ee91b8"
  end
  resource "paimon-connector" do
    url "https://search.maven.org/remotecontent?filepath=org/apache/flink/flink-cdc-pipeline-connector-paimon/3.2.0/flink-cdc-pipeline-connector-paimon-3.2.0.jar"
    sha256 "8dd4274f5e8b4e71bdb3ad765908c15de9ccacc95f2fa16afab143c6ddffcea8"
  end
  resource "kafka-connector" do
    url "https://search.maven.org/remotecontent?filepath=org/apache/flink/flink-cdc-pipeline-connector-kafka/3.2.0/flink-cdc-pipeline-connector-kafka-3.2.0.jar"
    sha256 "f1b67168fd31b1b5a83253de305066c0b51178f1afd2e07b29f1b4c6931b1345"
  end
  resource "doris-connector" do
    url "https://search.maven.org/remotecontent?filepath=org/apache/flink/flink-cdc-pipeline-connector-doris/3.2.0/flink-cdc-pipeline-connector-doris-3.2.0.jar"
    sha256 "249d8e61a561144c91f94d8d2aa1a5d6ce33514cce952e4079d66e8e27a1f79c"
  end
  resource "starrocks-connector" do
    url "https://search.maven.org/remotecontent?filepath=org/apache/flink/flink-cdc-pipeline-connector-starrocks/3.2.0/flink-cdc-pipeline-connector-starrocks-3.2.0.jar"
    sha256 "4034739181383511145c5175e7342f634cb0b87c73e59915ebf8fe443e9057ce"
  end
  resource "values-connector" do
    url "https://search.maven.org/remotecontent?filepath=org/apache/flink/flink-cdc-pipeline-connector-values/3.2.0/flink-cdc-pipeline-connector-values-3.2.0.jar"
    sha256 "973d87b888c2a178f7ca239b01a1fd3416fb6c2a661d78303960fc593bd9e255"
  end

  def install
    # Install launch script
    mv "bin/flink-cdc.sh", "bin/flink-cdc"
    libexec.install "bin"
    bin.write_exec_script libexec/"bin/flink-cdc"
    inreplace libexec/"bin/flink-cdc" do |s|
      # Specify FLINK_CDC_HOME explicitly
      s.sub! "FLINK_CDC_HOME=\"$SCRIPT_DIR\"/..", "FLINK_CDC_HOME=\"#{libexec}\""
    end

    # Install connector libraries
    libexec.install "lib"
    resources.each { |connector| (libexec/"lib").install connector }

    # Store configs in etc, outside of keg
    pkgetc.install Dir["conf/*"]
    libexec.install_symlink pkgetc => "conf"
  end

  def post_install
    (var/"log/apache-flink-cdc").mkpath
    libexec.install_symlink var/"log/apache-flink-cdc" => "log"
  end

  test do
    (testpath/"test-pipeline.yaml").write <<~EOS
      source:
        name: Dummy data source
        type: values

      sink:
        name: Dummy data sink
        type: values

      pipeline:
        name: Dummy pipeline job
        parallelism: 1
    EOS
    (testpath/"log").mkpath
    ENV["FLINK_LOG_DIR"] = testpath/"log"
    flink_home = Formula["apache-flink"].libexec
    system flink_home/"bin/start-cluster.sh"
    output = shell_output "#{bin}/flink-cdc --flink-home #{flink_home} #{testpath}/test-pipeline.yaml"
    assert_match "Pipeline has been submitted to cluster.", output
    system flink_home/"bin/stop-cluster.sh"
  end
end
