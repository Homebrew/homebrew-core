class ApacheFlinkCdc < Formula
  desc "Flink CDC is a streaming data integration tool"
  homepage "https://nightlies.apache.org/flink/flink-cdc-docs-stable"
  url "https://www.apache.org/dyn/mirrors/mirrors.cgi?action=download&filename=flink/flink-cdc-3.1.1/flink-cdc-3.1.1-bin.tar.gz"
  mirror "https://archive.apache.org/dist/flink/flink-cdc-3.1.1/flink-cdc-3.1.1-bin.tar.gz"
  sha256 "1f014be61fde2b881985f0928173f6f509a73556d247019843ccef282ad26504"
  license "Apache-2.0"
  head "https://github.com/apache/flink-cdc.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "2980ff1f34ddc49bd3d960256aacadbdd4713b8a0d62e2b6b08c60c6bf5810ea"
  end

  depends_on "apache-flink" => :test

  resource "mysql-connector" do
    url "https://search.maven.org/remotecontent?filepath=org/apache/flink/flink-cdc-pipeline-connector-mysql/3.1.1/flink-cdc-pipeline-connector-mysql-3.1.1.jar"
    sha256 "82baa189c57720484dfbb95bc57e0090a670c53a4e7b51c0b12940e1abbb2168"
  end
  resource "paimon-connector" do
    url "https://search.maven.org/remotecontent?filepath=org/apache/flink/flink-cdc-pipeline-connector-paimon/3.1.1/flink-cdc-pipeline-connector-paimon-3.1.1.jar"
    sha256 "85c4ca730bad4e1c43d16ba80116eeb541822eb195de7d54e8d4c659c43d49d8"
  end
  resource "kafka-connector" do
    url "https://search.maven.org/remotecontent?filepath=org/apache/flink/flink-cdc-pipeline-connector-kafka/3.1.1/flink-cdc-pipeline-connector-kafka-3.1.1.jar"
    sha256 "c8d34ed1fa4e5da99e120a4b66610a91d230a5ab7c0834aaa8c0eba9203c42cd"
  end
  resource "doris-connector" do
    url "https://search.maven.org/remotecontent?filepath=org/apache/flink/flink-cdc-pipeline-connector-doris/3.1.1/flink-cdc-pipeline-connector-doris-3.1.1.jar"
    sha256 "9e8d89275542592634feaad631533783728cc2f296f367c004654359d605204e"
  end
  resource "starrocks-connector" do
    url "https://search.maven.org/remotecontent?filepath=org/apache/flink/flink-cdc-pipeline-connector-starrocks/3.1.1/flink-cdc-pipeline-connector-starrocks-3.1.1.jar"
    sha256 "827b1b767d07d4c07f19170e4219b6b255c8d6920f012d447ef12a331fc0521e"
  end
  resource "values-connector" do
    url "https://search.maven.org/remotecontent?filepath=org/apache/flink/flink-cdc-pipeline-connector-values/3.1.1/flink-cdc-pipeline-connector-values-3.1.1.jar"
    sha256 "bb22b67b6db89026d6279b3e4bfb21e45516ed179913e668e00f93d11516bb1f"
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
