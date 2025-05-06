class ApacheFlinkCdc < Formula
  desc "Flink CDC is a streaming data integration tool"
  homepage "https://nightlies.apache.org/flink/flink-cdc-docs-stable/"
  url "https://www.apache.org/dyn/mirrors/mirrors.cgi?action=download&filename=flink/flink-cdc-3.3.0/flink-cdc-3.3.0-bin.tar.gz"
  mirror "https://archive.apache.org/dist/flink/flink-cdc-3.3.0/flink-cdc-3.3.0-bin.tar.gz"
  sha256 "efb6a5e36bcb85550c367cb39104ee7fcbacfd8124190a2fc3e547ca19446719"
  license "Apache-2.0"
  revision 1
  head "https://github.com/apache/flink-cdc.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "1cef7a93c789288ae90f0be233b2891a553f12bdee58bdd2e7ccaedf38da477e"
  end

  depends_on "apache-flink@1" => :test

  # See: https://github.com/apache/flink-cdc/blob/master/docs/content/docs/connectors/pipeline-connectors/overview.md#supported-connectors
  resource "mysql-connector" do
    url "https://search.maven.org/remotecontent?filepath=org/apache/flink/flink-cdc-pipeline-connector-mysql/3.3.0/flink-cdc-pipeline-connector-mysql-3.3.0.jar"
    sha256 "6e1af3675279e11c3e0240ca0475910c13bf75ecfd1ab23c0077a5fabc65c44a"
  end
  resource "oceanbase-connector" do
    url "https://search.maven.org/remotecontent?filepath=org/apache/flink/flink-cdc-pipeline-connector-oceanbase/3.3.0/flink-cdc-pipeline-connector-oceanbase-3.3.0.jar"
    sha256 "1de0ca47dc3f495b585e5f8f63c182f9e2f6c5bb6ed895392a65b2255d7c3c8f"
  end
  resource "paimon-connector" do
    url "https://search.maven.org/remotecontent?filepath=org/apache/flink/flink-cdc-pipeline-connector-paimon/3.3.0/flink-cdc-pipeline-connector-paimon-3.3.0.jar"
    sha256 "aff379b173bbde7383ef703211f63cf4e0e1eaac8bba7af1757ccf60fc2b2126"
  end
  resource "kafka-connector" do
    url "https://search.maven.org/remotecontent?filepath=org/apache/flink/flink-cdc-pipeline-connector-kafka/3.3.0/flink-cdc-pipeline-connector-kafka-3.3.0.jar"
    sha256 "988af808ba3c2b1bc2ac7c4e79388615ecd2d0614b5ccba48362b526ae1b98e9"
  end
  resource "maxcompute-connector" do
    url "https://search.maven.org/remotecontent?filepath=org/apache/flink/flink-cdc-pipeline-connector-maxcompute/3.3.0/flink-cdc-pipeline-connector-maxcompute-3.3.0.jar"
    sha256 "f2388915ace24911cb56f32c31e5cc387d968283cfb06333c8e43651108e35a6"
  end
  resource "doris-connector" do
    url "https://search.maven.org/remotecontent?filepath=org/apache/flink/flink-cdc-pipeline-connector-doris/3.3.0/flink-cdc-pipeline-connector-doris-3.3.0.jar"
    sha256 "112981b8bb216fa08928c12abc0a7ce3d2772f22c06d417e2426884e4f880304"
  end
  resource "elasticsearch-connector" do
    url "https://search.maven.org/remotecontent?filepath=org/apache/flink/flink-cdc-pipeline-connector-elasticsearch/3.3.0/flink-cdc-pipeline-connector-elasticsearch-3.3.0.jar"
    sha256 "41ca15269df57a57576740fb75e3a00a62bc7e0733b021f3844c50a05bf9610c"
  end
  resource "starrocks-connector" do
    url "https://search.maven.org/remotecontent?filepath=org/apache/flink/flink-cdc-pipeline-connector-starrocks/3.3.0/flink-cdc-pipeline-connector-starrocks-3.3.0.jar"
    sha256 "3bf443e4f339dc1532a2fb3870d014be4f40fb82ac58edbb09dde284a64886c0"
  end
  resource "values-connector" do
    url "https://search.maven.org/remotecontent?filepath=org/apache/flink/flink-cdc-pipeline-connector-values/3.3.0/flink-cdc-pipeline-connector-values-3.3.0.jar"
    sha256 "0854e61ba6016df5c13ae99fe78aabc278a5bbf4bcb3c029402a6bf7de96a93b"
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
    (testpath/"test-pipeline.yaml").write <<~YAML
      source:
        name: Dummy data source
        type: values

      sink:
        name: Dummy data sink
        type: values

      pipeline:
        name: Dummy pipeline job
        parallelism: 1
    YAML
    (testpath/"log").mkpath
    ENV["FLINK_LOG_DIR"] = testpath/"log"
    flink_home = Formula["apache-flink@1"].libexec
    system flink_home/"bin/start-cluster.sh"
    output = shell_output "#{bin}/flink-cdc --flink-home #{flink_home} #{testpath}/test-pipeline.yaml"
    assert_match "Pipeline has been submitted to cluster.", output
    system flink_home/"bin/stop-cluster.sh"
  end
end
