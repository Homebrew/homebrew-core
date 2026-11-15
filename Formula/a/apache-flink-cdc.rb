class ApacheFlinkCdc < Formula
  desc "Flink CDC is a streaming data integration tool"
  homepage "https://nightlies.apache.org/flink/flink-cdc-docs-stable/"
  url "https://www.apache.org/dyn/closer.lua?path=flink/flink-cdc-3.7.0/flink-cdc-3.7.0-2.2-bin.tar.gz"
  mirror "https://archive.apache.org/dist/flink/flink-cdc-3.7.0/flink-cdc-3.7.0-2.2-bin.tar.gz"
  version "3.7.0"
  sha256 "0f282635bae64818ee6792db312fe517955980028e51174b8348c57bd00ea592"
  license "Apache-2.0"
  head "https://github.com/apache/flink-cdc.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "09a708542b335241347e26a148296b99b7d679d4a4d72c248d1871321b759580"
  end

  depends_on "apache-flink" => :test

  # See: https://github.com/apache/flink-cdc/blob/master/docs/content/docs/connectors/pipeline-connectors/overview.md#supported-connectors
  resource "mysql-connector" do
    url "https://search.maven.org/remotecontent?filepath=org/apache/flink/flink-cdc-pipeline-connector-mysql/3.7.0-2.2/flink-cdc-pipeline-connector-mysql-3.7.0-2.2.jar"
    sha256 "f56f8d11baf864b1cd12755bc725207e530a20d546252b6c8ff2f60ae4dc332d"

    livecheck do
      formula :parent
    end
  end

  resource "oceanbase-connector" do
    url "https://search.maven.org/remotecontent?filepath=org/apache/flink/flink-cdc-pipeline-connector-oceanbase/3.7.0-2.2/flink-cdc-pipeline-connector-oceanbase-3.7.0-2.2.jar"
    sha256 "7e4997d316c2821284e73b766e37e8755affdb37aa3d187c14af6b11f5880c9c"

    livecheck do
      formula :parent
    end
  end

  resource "paimon-connector" do
    url "https://search.maven.org/remotecontent?filepath=org/apache/flink/flink-cdc-pipeline-connector-paimon/3.7.0-2.2/flink-cdc-pipeline-connector-paimon-3.7.0-2.2.jar"
    sha256 "c83f455a6641aee32d13ebcacf1143827d87291cacfb7c1d83bb42a8a38b26f6"

    livecheck do
      formula :parent
    end
  end

  resource "kafka-connector" do
    url "https://search.maven.org/remotecontent?filepath=org/apache/flink/flink-cdc-pipeline-connector-kafka/3.7.0-2.2/flink-cdc-pipeline-connector-kafka-3.7.0-2.2.jar"
    sha256 "c21d125e94ff76811a6efd45eb7fbf8bc1c694f6b3dcbe5b70b3c370c6c2feda"

    livecheck do
      formula :parent
    end
  end

  resource "maxcompute-connector" do
    url "https://search.maven.org/remotecontent?filepath=org/apache/flink/flink-cdc-pipeline-connector-maxcompute/3.7.0-2.2/flink-cdc-pipeline-connector-maxcompute-3.7.0-2.2.jar"
    sha256 "b7e52ec7c071852fd95b282b7975203d350d90ea75258e1361bb4bf16be8e28e"

    livecheck do
      formula :parent
    end
  end

  resource "doris-connector" do
    url "https://search.maven.org/remotecontent?filepath=org/apache/flink/flink-cdc-pipeline-connector-doris/3.7.0-2.2/flink-cdc-pipeline-connector-doris-3.7.0-2.2.jar"
    sha256 "afe73307cce7e310e875203fa1ea6aedfa5a9016f9ff721cdcd49b4898863127"

    livecheck do
      formula :parent
    end
  end

  resource "elasticsearch-connector" do
    url "https://search.maven.org/remotecontent?filepath=org/apache/flink/flink-cdc-pipeline-connector-elasticsearch/3.7.0-2.2/flink-cdc-pipeline-connector-elasticsearch-3.7.0-2.2.jar"
    sha256 "3c4d5f23017faaa98aa992d00432f9f8f7dc55255eb78ea50ce68f8bb4a7fb3f"

    livecheck do
      formula :parent
    end
  end

  resource "starrocks-connector" do
    url "https://search.maven.org/remotecontent?filepath=org/apache/flink/flink-cdc-pipeline-connector-starrocks/3.7.0-2.2/flink-cdc-pipeline-connector-starrocks-3.7.0-2.2.jar"
    sha256 "7c1a1e2b9956a9771d8b0b8ea80f18db6394677179d7c6057acffbe0231ac5c8"

    livecheck do
      formula :parent
    end
  end

  resource "values-connector" do
    url "https://search.maven.org/remotecontent?filepath=org/apache/flink/flink-cdc-pipeline-connector-values/3.7.0-2.2/flink-cdc-pipeline-connector-values-3.7.0-2.2.jar"
    sha256 "427988f7c64779fd8277f0e01b76a37b017eb81a25cb05624d6a0d2aa54de4d4"

    livecheck do
      formula :parent
    end
  end

  resource "iceberg-connector" do
    url "https://search.maven.org/remotecontent?filepath=org/apache/flink/flink-cdc-pipeline-connector-iceberg/3.7.0-2.2/flink-cdc-pipeline-connector-iceberg-3.7.0-2.2.jar"
    sha256 "ca077ff526a60d7a02896ae4772ce453cb257b669a6000bbbbdccbbaa70f2eff"

    livecheck do
      formula :parent
    end
  end

  allow_network_access! :test

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
    flink_home = formula_opt_libexec("apache-flink")
    system flink_home/"bin/start-cluster.sh"
    output = shell_output "#{bin}/flink-cdc --flink-home #{flink_home} #{testpath}/test-pipeline.yaml"
    assert_match "Pipeline has been submitted to cluster.", output
    system flink_home/"bin/stop-cluster.sh"
  end
end
