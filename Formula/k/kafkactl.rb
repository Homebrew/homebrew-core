class Kafkactl < Formula
  desc "CLI for managing Apache Kafka"
  homepage "https://deviceinsight.github.io/kafkactl/"
  url "https://github.com/deviceinsight/kafkactl/archive/refs/tags/v5.20.0.tar.gz"
  sha256 "e120f614d52d4306c3093fdf2ac5ff84f7357e6423c95cb78a9b06ff56795de0"
  license "Apache-2.0"
  head "https://github.com/deviceinsight/kafkactl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "25b8ab6bcc0a597dda6a232854673f84c23b1e4c7976517e4c850e04e771280e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "25b8ab6bcc0a597dda6a232854673f84c23b1e4c7976517e4c850e04e771280e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "25b8ab6bcc0a597dda6a232854673f84c23b1e4c7976517e4c850e04e771280e"
    sha256 cellar: :any_skip_relocation, sonoma:        "d8dd1d1326a6932e6800532de8e40f286d3b69117c861d4963b0d386356ea8d5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a14a99bb692967f33c6826afd40d9196004c73731f9cfd00df16aa4de839edde"
    sha256 cellar: :any,                 x86_64_linux:  "27d450108d63d3ad4dd4a674a30d3bd629680ea143fb2c9b21e2439a602f5bbf"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
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
