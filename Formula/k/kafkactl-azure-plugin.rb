class KafkactlAzurePlugin < Formula
  desc "Azure Plugin for kafkactl"
  homepage "https://deviceinsight.github.io/kafkactl/"
  url "https://github.com/deviceinsight/kafkactl-plugins/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "9fcab4135e68ffba6af40db21ab4c36f798a502be402f6c2d6557d316084b445"
  license "Apache-2.0"

  depends_on "go" => :build
  depends_on "kafkactl"

  def install
    Dir.chdir("azure") do
      ldflags = %W[
        -s -w
        -X main.Version=v#{version}
        -X main.GitCommit=#{tap.user}
        -X main.BuildTime=#{time.iso8601}
      ]
      system "go", "build", *std_go_args(ldflags:)
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kafkactl-azure-plugin 2>&1", 1)
    config_file = testpath/".kafkactl.yml"
    config_file.write <<~YAML
      contexts:
          default:
              brokers:
                  - unknown-namespace.servicebus.windows.net:9093
              sasl:
                  enabled: true
                  mechanism: oauth
                  tokenprovider:
                      plugin: azure
              tls:
                  enabled: true
    YAML

    ENV["KAFKA_CTL_PLUGIN_PATHS"] = bin

    kafkactl = Formula["kafkactl"].bin/"kafkactl"
    output = shell_output("#{kafkactl} -C #{config_file} get topics -V 2>&1", 1)
    assert_match "kafkactl-azure-plugin: plugin initialized", output
  end
end
