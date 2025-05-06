class Kafkactl < Formula
  desc "CLI for managing Apache Kafka"
  homepage "https://deviceinsight.github.io/kafkactl/"
  url "https://github.com/deviceinsight/kafkactl/archive/refs/tags/v5.7.0.tar.gz"
  sha256 "fa3b55d4179ab0c100a9d3d539b1e262ee619d1f99344c89468215bb41474c6d"
  license "Apache-2.0"
  head "https://github.com/deviceinsight/kafkactl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4685763409834c52c3fbcb962b14d1deb3f0b9df7a5de1c9c1a0675c0aff2e0c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4685763409834c52c3fbcb962b14d1deb3f0b9df7a5de1c9c1a0675c0aff2e0c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4685763409834c52c3fbcb962b14d1deb3f0b9df7a5de1c9c1a0675c0aff2e0c"
    sha256 cellar: :any_skip_relocation, sonoma:        "5691e36f0f70866d0df11cd1b1fc69e421b9ff327842683f63566d1b66f8c1ab"
    sha256 cellar: :any_skip_relocation, ventura:       "5691e36f0f70866d0df11cd1b1fc69e421b9ff327842683f63566d1b66f8c1ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1fce6d1066b6b908d8ef983a2b9bf63001c898176d07a2a1b03ffa266985c2c4"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/deviceinsight/kafkactl/v5/cmd.Version=#{version}
      -X github.com/deviceinsight/kafkactl/v5/cmd.GitCommit=#{tap.user}
      -X github.com/deviceinsight/kafkactl/v5/cmd.BuildTime=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"kafkactl", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kafkactl version")

    output = shell_output("#{bin}/kafkactl produce greetings 2>&1", 1)
    assert_match "Failed to open Kafka producer", output
  end
end
