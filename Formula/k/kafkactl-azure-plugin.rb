class KafkactlAzurePlugin < Formula
  desc "Azure Plugin for kafkactl"
  homepage "https://deviceinsight.github.io/kafkactl/"
  url "https://github.com/deviceinsight/kafkactl-plugins/archive/refs/tags/v1.3.1.tar.gz"
  sha256 "f7f5b961061c863131a9f84e8a6aa7d7273a16b1c3ad4fb86888edebda345eb1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2c2a3747deb8597b6b3937c23ac69eb7231c0b37b446a269281cd3069111ff0f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1a3e592a07ba5b304675f393e1cf4301c3665565790e19d0541825b5058e2471"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1a3e592a07ba5b304675f393e1cf4301c3665565790e19d0541825b5058e2471"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1a3e592a07ba5b304675f393e1cf4301c3665565790e19d0541825b5058e2471"
    sha256 cellar: :any_skip_relocation, sonoma:        "98e2a44851ac0c34061a2844fed3263583df18e271511b490c461181caa18fc2"
    sha256 cellar: :any_skip_relocation, ventura:       "98e2a44851ac0c34061a2844fed3263583df18e271511b490c461181caa18fc2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bc616e8c44205c34039c53e1c8df5a974a6cbd498216324dfb2ecd36462e9297"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "52e1c850b386e6b1c77983111c37c70ac59011e661eb559eed90b7989f48d00f"
  end

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
