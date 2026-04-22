class ApacheFlinkCdc < Formula
  desc "Flink CDC is a streaming data integration tool"
  homepage "https://nightlies.apache.org/flink/flink-cdc-docs-stable/"
  url "https://www.apache.org/dyn/closer.lua?path=flink/flink-cdc-3.6.0/flink-cdc-3.6.0-2.2-bin.tar.gz"
  mirror "https://archive.apache.org/dist/flink/flink-cdc-3.6.0/flink-cdc-3.6.0-2.2-bin.tar.gz"
  version "3.6.0"
  sha256 "a361cd61c32be7f5056878ee98439ea8c9b50846bb9bcc08b5b305249dac045b"
  license "Apache-2.0"
  head "https://github.com/apache/flink-cdc.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "3b5908aaa8bf46a8d89b07b55f20db383002dde1b98a8ef00e18f6d094928d59"
  end

  depends_on "apache-flink" => :test

  # See: https://github.com/apache/flink-cdc/blob/master/docs/content/docs/connectors/pipeline-connectors/overview.md#supported-connectors
  resource "mysql-connector" do
    url "https://search.maven.org/remotecontent?filepath=org/apache/flink/flink-cdc-pipeline-connector-mysql/3.6.0-2.2/flink-cdc-pipeline-connector-mysql-3.6.0-2.2.jar"
    sha256 "6d559f2b05571368b4049c52b37d3509cd34f87e7e0bdb225ed2d4e837241e6c"

    livecheck do
      formula :parent
    end
  end

  resource "oceanbase-connector" do
    url "https://search.maven.org/remotecontent?filepath=org/apache/flink/flink-cdc-pipeline-connector-oceanbase/3.6.0-2.2/flink-cdc-pipeline-connector-oceanbase-3.6.0-2.2.jar"
    sha256 "4034f72961b71951ba1bf59df16a8c837c211ac5e43407853d1a470c23ffb19f"

    livecheck do
      formula :parent
    end
  end

  resource "paimon-connector" do
    url "https://search.maven.org/remotecontent?filepath=org/apache/flink/flink-cdc-pipeline-connector-paimon/3.6.0-2.2/flink-cdc-pipeline-connector-paimon-3.6.0-2.2.jar"
    sha256 "cd9ac95997b330ec9a166039f715757febb0234f2b558cd215dddf0f898e1d94"

    livecheck do
      formula :parent
    end
  end

  resource "kafka-connector" do
    url "https://search.maven.org/remotecontent?filepath=org/apache/flink/flink-cdc-pipeline-connector-kafka/3.6.0-2.2/flink-cdc-pipeline-connector-kafka-3.6.0-2.2.jar"
    sha256 "a32859c1fdd098e4da333cdb739c06ba20fe99204b70196e55f6f8e8cba922da"

    livecheck do
      formula :parent
    end
  end

  resource "maxcompute-connector" do
    url "https://search.maven.org/remotecontent?filepath=org/apache/flink/flink-cdc-pipeline-connector-maxcompute/3.6.0-2.2/flink-cdc-pipeline-connector-maxcompute-3.6.0-2.2.jar"
    sha256 "2c34c0a49dfb55f9519966968300861a2c54e07b4db5521b078d00b89ca0ce3e"

    livecheck do
      formula :parent
    end
  end

  resource "doris-connector" do
    url "https://search.maven.org/remotecontent?filepath=org/apache/flink/flink-cdc-pipeline-connector-doris/3.6.0-2.2/flink-cdc-pipeline-connector-doris-3.6.0-2.2.jar"
    sha256 "2c08f26684bcd2dd892488b9662c4f7270034a6c77a573df39f4a92f51cf019a"

    livecheck do
      formula :parent
    end
  end

  resource "elasticsearch-connector" do
    url "https://search.maven.org/remotecontent?filepath=org/apache/flink/flink-cdc-pipeline-connector-elasticsearch/3.6.0-2.2/flink-cdc-pipeline-connector-elasticsearch-3.6.0-2.2.jar"
    sha256 "39c50702180428c6b72835f76acc65e25b4d9947bfd6f63aa51e0b5f47b99bd2"

    livecheck do
      formula :parent
    end
  end

  resource "starrocks-connector" do
    url "https://search.maven.org/remotecontent?filepath=org/apache/flink/flink-cdc-pipeline-connector-starrocks/3.6.0-2.2/flink-cdc-pipeline-connector-starrocks-3.6.0-2.2.jar"
    sha256 "517e8ea1f4d686c12582b3e4c38e6b937b07812a9ce26d36fb07d4e129e6ac7b"

    livecheck do
      formula :parent
    end
  end

  resource "values-connector" do
    url "https://search.maven.org/remotecontent?filepath=org/apache/flink/flink-cdc-pipeline-connector-values/3.6.0-2.2/flink-cdc-pipeline-connector-values-3.6.0-2.2.jar"
    sha256 "5fb268901b4935e106a70bb6887f7a471dd86aa724b2f9fca8f0815c68b90130"

    livecheck do
      formula :parent
    end
  end

  resource "iceberg-connector" do
    url "https://search.maven.org/remotecontent?filepath=org/apache/flink/flink-cdc-pipeline-connector-iceberg/3.6.0-2.2/flink-cdc-pipeline-connector-iceberg-3.6.0-2.2.jar"
    sha256 "65cbb8c7643ccc7648ced4d9a85bde3edaba2cf65c6b9f75f839c9a25e9620cc"

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
    flink_home = Formula["apache-flink"].libexec
    system flink_home/"bin/start-cluster.sh"
    output = shell_output "#{bin}/flink-cdc --flink-home #{flink_home} #{testpath}/test-pipeline.yaml"
    assert_match "Pipeline has been submitted to cluster.", output
    system flink_home/"bin/stop-cluster.sh"
  end
end
