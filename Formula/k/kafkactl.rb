class Kafkactl < Formula
  desc "CLI for managing Apache Kafka"
  homepage "https://deviceinsight.github.io/kafkactl/"
  url "https://github.com/deviceinsight/kafkactl/archive/refs/tags/v5.8.0.tar.gz"
  sha256 "fe76c997cdc10aa52d984b6abcc14fe4c832182a1e03e1dd6225f38a4f5b5615"
  license "Apache-2.0"
  head "https://github.com/deviceinsight/kafkactl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f5deecb945ab1c7f60dd9231cbc7ad9e921260a6c3c09ae950e65754b68716d7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f5deecb945ab1c7f60dd9231cbc7ad9e921260a6c3c09ae950e65754b68716d7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f5deecb945ab1c7f60dd9231cbc7ad9e921260a6c3c09ae950e65754b68716d7"
    sha256 cellar: :any_skip_relocation, sonoma:        "d6b7d4466e3d793e4dda82a96539f79851b7424219f7724aedcdb4b2fdd36f43"
    sha256 cellar: :any_skip_relocation, ventura:       "d6b7d4466e3d793e4dda82a96539f79851b7424219f7724aedcdb4b2fdd36f43"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "467ce6793c7872edebdd2f4b417249af775103b404e25d0ca4033fdfea2ed161"
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
