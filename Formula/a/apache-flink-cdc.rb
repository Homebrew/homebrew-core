class ApacheFlinkCdc < Formula
  desc "Flink CDC is a streaming data integration tool"
  homepage "https://nightlies.apache.org/flink/flink-cdc-docs-stable/"
  url "https://www.apache.org/dyn/mirrors/mirrors.cgi?action=download&filename=flink/flink-cdc-3.4.0/flink-cdc-3.4.0-bin.tar.gz"
  mirror "https://archive.apache.org/dist/flink/flink-cdc-3.4.0/flink-cdc-3.4.0-bin.tar.gz"
  sha256 "d85090e41d077cb8ccbe6fdaf33807c234f1b4de685751e0fee3ba3be5a737e4"
  license "Apache-2.0"
  revision 1
  head "https://github.com/apache/flink-cdc.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "89a4c157f350f28c507ad091a44d06d018107a9b41dcadc35821e8b47ea81930"
  end

  depends_on "apache-flink@1" => :test

  # See: https://github.com/apache/flink-cdc/blob/master/docs/content/docs/connectors/pipeline-connectors/overview.md#supported-connectors
  resource "mysql-connector" do
    url "https://search.maven.org/remotecontent?filepath=org/apache/flink/flink-cdc-pipeline-connector-mysql/3.4.0/flink-cdc-pipeline-connector-mysql-3.4.0.jar"
    sha256 "23a4acd064d708209495eae23350ecfab4d452515fac6fc97b0bb8b67e934eaa"
  end
  resource "oceanbase-connector" do
    url "https://search.maven.org/remotecontent?filepath=org/apache/flink/flink-cdc-pipeline-connector-oceanbase/3.4.0/flink-cdc-pipeline-connector-oceanbase-3.4.0.jar"
    sha256 "fc52bb350a9c1e12ac57e316c282cd00ef3b1955e915e70b01ff3e6c860ad138"
  end
  resource "paimon-connector" do
    url "https://search.maven.org/remotecontent?filepath=org/apache/flink/flink-cdc-pipeline-connector-paimon/3.4.0/flink-cdc-pipeline-connector-paimon-3.4.0.jar"
    sha256 "2a905418b34aaea581d90bbab58ade9d9dc7be51a3601b13c921c39d38285b97"
  end
  resource "kafka-connector" do
    url "https://search.maven.org/remotecontent?filepath=org/apache/flink/flink-cdc-pipeline-connector-kafka/3.4.0/flink-cdc-pipeline-connector-kafka-3.4.0.jar"
    sha256 "b19b16ebcab429cadbd9a30937d2af4a5fd02e57762118b3495b842342b8bfe6"
  end
  resource "maxcompute-connector" do
    url "https://search.maven.org/remotecontent?filepath=org/apache/flink/flink-cdc-pipeline-connector-maxcompute/3.4.0/flink-cdc-pipeline-connector-maxcompute-3.4.0.jar"
    sha256 "8ec4ca13eee03a4cac10dbbd678ce439d1e6192b08833b4867027e3b5bc095ba"
  end
  resource "doris-connector" do
    url "https://search.maven.org/remotecontent?filepath=org/apache/flink/flink-cdc-pipeline-connector-doris/3.4.0/flink-cdc-pipeline-connector-doris-3.4.0.jar"
    sha256 "419ce715dc300da2e5b849a521054603dc4262e337aa6ae5426a48b9b063e312"
  end
  resource "elasticsearch-connector" do
    url "https://search.maven.org/remotecontent?filepath=org/apache/flink/flink-cdc-pipeline-connector-elasticsearch/3.4.0/flink-cdc-pipeline-connector-elasticsearch-3.4.0.jar"
    sha256 "85490450e01f65bff075c5f26228026244590b102f7bbe22cee82d3c508de983"
  end
  resource "starrocks-connector" do
    url "https://search.maven.org/remotecontent?filepath=org/apache/flink/flink-cdc-pipeline-connector-starrocks/3.4.0/flink-cdc-pipeline-connector-starrocks-3.4.0.jar"
    sha256 "1e95f12c509b455361bc0d6ae4f6c330aa3f0d33dd6aaed5735d8c2748443896"
  end
  resource "values-connector" do
    url "https://search.maven.org/remotecontent?filepath=org/apache/flink/flink-cdc-pipeline-connector-values/3.4.0/flink-cdc-pipeline-connector-values-3.4.0.jar"
    sha256 "abfe81db11388aebb26419e875ccf813b6e5307f7cc2fbb4ef81a9a2ff72574f"
  end
  resource "iceberg-connector" do
    url "https://search.maven.org/remotecontent?filepath=org/apache/flink/flink-cdc-pipeline-connector-iceberg/3.4.0/flink-cdc-pipeline-connector-iceberg-3.4.0.jar"
    sha256 "b3be61da77c87c7dcd03b1837d3ae90fa58a9ce2fd497b6f0066477e59895ec5"
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
