class Kafkactl < Formula
  desc "CLI for managing Apache Kafka"
  homepage "https://deviceinsight.github.io/kafkactl/"
  url "https://github.com/deviceinsight/kafkactl/archive/refs/tags/v5.19.0.tar.gz"
  sha256 "e203210eb5b58d321bbb4e2a917bdbffbada0f213009e28f8f0705e633b9ce75"
  license "Apache-2.0"
  head "https://github.com/deviceinsight/kafkactl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4d95d7ebf8ff3e1c94f18724d521f17560a3319445452259836b485404869389"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4d95d7ebf8ff3e1c94f18724d521f17560a3319445452259836b485404869389"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4d95d7ebf8ff3e1c94f18724d521f17560a3319445452259836b485404869389"
    sha256 cellar: :any_skip_relocation, sonoma:        "328ae0ff89cc97beff84ccf0995dd098750d06076b898283311787e066a0bada"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8b788c0ec91c1a3be73f10345bb5f8ba2fb71073d4364b91a8e869b65df34f81"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bcc25a952ebfc83251847dd091671799a2f857288309f332a3051362b7580c5f"
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
