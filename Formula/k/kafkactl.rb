class Kafkactl < Formula
  desc "CLI for managing Apache Kafka"
  homepage "https://deviceinsight.github.io/kafkactl/"
  url "https://github.com/deviceinsight/kafkactl/archive/refs/tags/v5.12.1.tar.gz"
  sha256 "25d1879185235c35fd327c4e96a403bb60188df82b2af3f9bfbb339adb0ae718"
  license "Apache-2.0"
  head "https://github.com/deviceinsight/kafkactl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a2bbf002ecd2fa96975654569f134e359d431942e3299b3672cb0f682d2f51b3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cc7f03811264ce46da940000d76df0b8ad19a750deafc527e3a896c3c86bf626"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cc7f03811264ce46da940000d76df0b8ad19a750deafc527e3a896c3c86bf626"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cc7f03811264ce46da940000d76df0b8ad19a750deafc527e3a896c3c86bf626"
    sha256 cellar: :any_skip_relocation, sonoma:        "8bfd0455fa9a33115b96144e8d1075d207f50e50956e77610fb6033e2a13efa4"
    sha256 cellar: :any_skip_relocation, ventura:       "8bfd0455fa9a33115b96144e8d1075d207f50e50956e77610fb6033e2a13efa4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "46f380d3848f162fe78de43e098f73c0a1ce57582764af64d7e93afae59b5fd2"
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

    generate_completions_from_executable(bin/"kafkactl", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kafkactl version")

    output = shell_output("#{bin}/kafkactl produce greetings 2>&1", 1)
    assert_match "Failed to open Kafka producer", output
  end
end
