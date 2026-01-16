class ApacheFlinkCdc < Formula
  desc "Flink CDC is a streaming data integration tool"
  homepage "https://nightlies.apache.org/flink/flink-cdc-docs-stable/"
  url "https://www.apache.org/dyn/mirrors/mirrors.cgi?action=download&filename=flink/flink-cdc-3.5.0/flink-cdc-3.5.0-bin.tar.gz"
  mirror "https://archive.apache.org/dist/flink/flink-cdc-3.5.0/flink-cdc-3.5.0-bin.tar.gz"
  sha256 "50938f2e0e4eeae46241fa077123d7071d27c91ba4ff44f7594620e6278773a7"
  license "Apache-2.0"
  head "https://github.com/apache/flink-cdc.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "68fe50aa347d8bea103b9f25ac983ac7fd078c7b82eeedb9589c888b73e754eb"
  end

  depends_on "apache-flink@1" => :test # Compatible version at https://flink.apache.org/downloads/#apache-flink-cdc

  # See: https://github.com/apache/flink-cdc/blob/master/docs/content/docs/connectors/pipeline-connectors/overview.md#supported-connectors
  resource "mysql-connector" do
    url "https://search.maven.org/remotecontent?filepath=org/apache/flink/flink-cdc-pipeline-connector-mysql/3.5.0/flink-cdc-pipeline-connector-mysql-3.5.0.jar"
    sha256 "60ace993199e26f3b06c45ff71732d974bbb4c8e35b960fd8d58ea6d37b21a0e"

    livecheck do
      formula :parent
    end
  end

  resource "oceanbase-connector" do
    url "https://search.maven.org/remotecontent?filepath=org/apache/flink/flink-cdc-pipeline-connector-oceanbase/3.5.0/flink-cdc-pipeline-connector-oceanbase-3.5.0.jar"
    sha256 "60ace993199e26f3b06c45ff71732d974bbb4c8e35b960fd8d58ea6d37b21a0e"

    livecheck do
      formula :parent
    end
  end

  resource "paimon-connector" do
    url "https://search.maven.org/remotecontent?filepath=org/apache/flink/flink-cdc-pipeline-connector-paimon/3.5.0/flink-cdc-pipeline-connector-paimon-3.5.0.jar"
    sha256 "0431fd6d42b9475506842b5409c37c35ac932e4a84d143d5c493c7d46fced74b"

    livecheck do
      formula :parent
    end
  end

  resource "kafka-connector" do
    url "https://search.maven.org/remotecontent?filepath=org/apache/flink/flink-cdc-pipeline-connector-kafka/3.5.0/flink-cdc-pipeline-connector-kafka-3.5.0.jar"
    sha256 "8f9ac34b28b72797ec8af0f402f382c75299a78df863c1ddd1a683919c7eac28"

    livecheck do
      formula :parent
    end
  end

  resource "maxcompute-connector" do
    url "https://search.maven.org/remotecontent?filepath=org/apache/flink/flink-cdc-pipeline-connector-maxcompute/3.5.0/flink-cdc-pipeline-connector-maxcompute-3.5.0.jar"
    sha256 "0b398c78f9431b44113ad32ed90616df49dcbf82b5d5703de2ed08c738dddb21"

    livecheck do
      formula :parent
    end
  end

  resource "doris-connector" do
    url "https://search.maven.org/remotecontent?filepath=org/apache/flink/flink-cdc-pipeline-connector-doris/3.5.0/flink-cdc-pipeline-connector-doris-3.5.0.jar"
    sha256 "1cbbdd5a296420b78e2b748867bbbb12d44384d0d11d8654312beb53eb140899"

    livecheck do
      formula :parent
    end
  end

  resource "elasticsearch-connector" do
    url "https://search.maven.org/remotecontent?filepath=org/apache/flink/flink-cdc-pipeline-connector-elasticsearch/3.5.0/flink-cdc-pipeline-connector-elasticsearch-3.5.0.jar"
    sha256 "d973b966bc5123cd378fb841f919312805e615cd6fd54dea3d2b4331ae081a30"

    livecheck do
      formula :parent
    end
  end

  resource "starrocks-connector" do
    url "https://search.maven.org/remotecontent?filepath=org/apache/flink/flink-cdc-pipeline-connector-starrocks/3.5.0/flink-cdc-pipeline-connector-starrocks-3.5.0.jar"
    sha256 "0848c35d0068329f5d90c5729df2814692677946bd42f34b68decebc23cdb3cf"

    livecheck do
      formula :parent
    end
  end

  resource "values-connector" do
    url "https://search.maven.org/remotecontent?filepath=org/apache/flink/flink-cdc-pipeline-connector-values/3.5.0/flink-cdc-pipeline-connector-values-3.5.0.jar"
    sha256 "075aa185925ac78b411ccad049ea3f5ecbb647d7054dbde653f4029a05ad7e16"

    livecheck do
      formula :parent
    end
  end

  resource "iceberg-connector" do
    url "https://search.maven.org/remotecontent?filepath=org/apache/flink/flink-cdc-pipeline-connector-iceberg/3.5.0/flink-cdc-pipeline-connector-iceberg-3.5.0.jar"
    sha256 "e11a47e6da8c2879acf1694387599e477180126b212224ab46e5819333667988"

    livecheck do
      formula :parent
    end
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
