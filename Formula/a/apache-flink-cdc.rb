class ApacheFlinkCdc < Formula
  desc "Flink CDC is a streaming data integration tool"
  homepage "https://nightlies.apache.org/flink/flink-cdc-docs-stable"
  url "https://www.apache.org/dyn/mirrors/mirrors.cgi?action=download&filename=flink/flink-cdc-3.1.0/flink-cdc-3.1.0-bin.tar.gz"
  mirror "https://archive.apache.org/dist/flink/flink-cdc-3.1.0/flink-cdc-3.1.0-bin.tar.gz"
  sha256 "f10b26a2368fd933c26b928fc118f1f1e28efec3ab58b0ec0c58f3f22906a9ab"
  license "Apache-2.0"
  head "https://github.com/apache/flink-cdc.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "1eed20a5fa3aa4b81f2bf40576dc65f6ce44546627fce3681c3a96ffe42e0b38"
  end

  depends_on "apache-flink" => :test

  resource "mysql-connector" do
    url "https://search.maven.org/remotecontent?filepath=org/apache/flink/flink-cdc-pipeline-connector-mysql/3.1.0/flink-cdc-pipeline-connector-mysql-3.1.0.jar"
    sha256 "2503a60a7e97c48a8b739d5cdb7270a93ba0d48bf073f9b88e1b34c915c4dd88"
  end
  resource "paimon-connector" do
    url "https://search.maven.org/remotecontent?filepath=org/apache/flink/flink-cdc-pipeline-connector-paimon/3.1.0/flink-cdc-pipeline-connector-paimon-3.1.0.jar"
    sha256 "799c723beb31379cb093a8caf01e402a126a8b6e5674d5cd579e819221e8fae8"
  end
  resource "kafka-connector" do
    url "https://search.maven.org/remotecontent?filepath=org/apache/flink/flink-cdc-pipeline-connector-kafka/3.1.0/flink-cdc-pipeline-connector-kafka-3.1.0.jar"
    sha256 "285de33acad088ec3b6da51bd58ab9e6326626ea025b48d9c048d2383ca2df6e"
  end
  resource "doris-connector" do
    url "https://search.maven.org/remotecontent?filepath=org/apache/flink/flink-cdc-pipeline-connector-doris/3.1.0/flink-cdc-pipeline-connector-doris-3.1.0.jar"
    sha256 "20d7744376ac152994e7de803100a792a1c583a5ca03a647c55e9039ae59237c"
  end
  resource "starrocks-connector" do
    url "https://search.maven.org/remotecontent?filepath=org/apache/flink/flink-cdc-pipeline-connector-starrocks/3.1.0/flink-cdc-pipeline-connector-starrocks-3.1.0.jar"
    sha256 "48ce5ffe3462c965f39ed3a97717f96739e3160759a5c6422b86ed151d6165ba"
  end
  resource "values-connector" do
    url "https://search.maven.org/remotecontent?filepath=org/apache/flink/flink-cdc-pipeline-connector-values/3.1.0/flink-cdc-pipeline-connector-values-3.1.0.jar"
    sha256 "7e16714c1395fa3139e60f189de54877020369e4ec2a7ec13cc4c7b84a26402e"
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
