class KafkactlAwsPlugin < Formula
  desc "AWS Plugin for kafkactl"
  homepage "https://deviceinsight.github.io/kafkactl/"
  url "https://github.com/deviceinsight/kafkactl-plugins/archive/refs/tags/v1.3.1.tar.gz"
  sha256 "f7f5b961061c863131a9f84e8a6aa7d7273a16b1c3ad4fb86888edebda345eb1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e838d485a417e87c9e482776ceab356ad7dce0274fda032766c2b82488c94bd7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1ac140f12e3dc048b7017d32738dc76a618ba535a531f78ade73ae48561e1748"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1ac140f12e3dc048b7017d32738dc76a618ba535a531f78ade73ae48561e1748"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1ac140f12e3dc048b7017d32738dc76a618ba535a531f78ade73ae48561e1748"
    sha256 cellar: :any_skip_relocation, sonoma:        "b37d14848bd63b210d5372b65d24d816555f9d944866acd7ac17e94123b3472a"
    sha256 cellar: :any_skip_relocation, ventura:       "b37d14848bd63b210d5372b65d24d816555f9d944866acd7ac17e94123b3472a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7b680ae3be1e51255b083f308540b469bcdde603747c25ef79a10f6237817919"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7c767ccab3c413b187272ebe7934d86990adbeec58bdba4d6a2b54f8b1b2efbc"
  end

  depends_on "go" => :build
  depends_on "kafkactl"

  def install
    Dir.chdir("aws") do
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
    assert_match version.to_s, shell_output("#{bin}/kafkactl-aws-plugin 2>&1", 1)
    config_file = testpath/".kafkactl.yml"
    config_file.write <<~YAML
      contexts:
          default:
              brokers:
                  - unknown-cluster.kafka.eu-west-1.amazonaws.com:9098
              sasl:
                  enabled: true
                  mechanism: oauth
                  tokenprovider:
                      plugin: aws
              tls:
                  enabled: true
    YAML

    ENV["KAFKA_CTL_PLUGIN_PATHS"] = bin

    kafkactl = Formula["kafkactl"].bin/"kafkactl"
    output = shell_output("#{kafkactl} -C #{config_file} get topics -V 2>&1", 1)
    assert_match "kafkactl-aws-plugin: plugin initialized", output
  end
end
