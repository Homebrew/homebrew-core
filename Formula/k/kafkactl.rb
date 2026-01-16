class Kafkactl < Formula
  desc "CLI for managing Apache Kafka"
  homepage "https://deviceinsight.github.io/kafkactl/"
  url "https://github.com/deviceinsight/kafkactl/archive/refs/tags/v5.17.0.tar.gz"
  sha256 "6a77d3860e26219a46877ea216ec6f4009c76a3b7d403b7d7b2074b0e0898ffc"
  license "Apache-2.0"
  head "https://github.com/deviceinsight/kafkactl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a9fb051984a66dee5f08e0c5d1755199e5fc4fddfc4670eb9d03f3be99a05077"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a9fb051984a66dee5f08e0c5d1755199e5fc4fddfc4670eb9d03f3be99a05077"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a9fb051984a66dee5f08e0c5d1755199e5fc4fddfc4670eb9d03f3be99a05077"
    sha256 cellar: :any_skip_relocation, sonoma:        "c2b191e8301889abb51b3dc07852c9540deba03dda1fb6a72f6b967ce3e469fc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cb9830ccc0e92c184425eb0ba33db04a5e297c94c64fd4b8a0b60d73f2595151"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "40198dd9e2091a6fd1e45540656b997a9685d0dc28db13c7991094e26ed7d2e6"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/deviceinsight/kafkactl/v5/cmd.Version=v#{version}
      -X github.com/deviceinsight/kafkactl/v5/cmd.GitCommit=#{tap.user}
      -X github.com/deviceinsight/kafkactl/v5/cmd.BuildTime=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"kafkactl", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kafkactl version")

    output = shell_output("#{bin}/kafkactl produce greetings 2>&1", 1)
    assert_match "Failed to open Kafka producer", output
  end
end
