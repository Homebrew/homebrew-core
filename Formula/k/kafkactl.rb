class Kafkactl < Formula
  desc "CLI for managing Apache Kafka"
  homepage "https://deviceinsight.github.io/kafkactl/"
  url "https://github.com/deviceinsight/kafkactl/archive/refs/tags/v5.15.0.tar.gz"
  sha256 "25fcf05acdbae85416cf75c6aa7867b1e3bf0d6ac5f3e895abbae5fa5f932281"
  license "Apache-2.0"
  head "https://github.com/deviceinsight/kafkactl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "566d73f4522ea7c60804fc6add49fe3be288bd6ec068e313a959c261c4fd3b57"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "566d73f4522ea7c60804fc6add49fe3be288bd6ec068e313a959c261c4fd3b57"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "566d73f4522ea7c60804fc6add49fe3be288bd6ec068e313a959c261c4fd3b57"
    sha256 cellar: :any_skip_relocation, sonoma:        "c89d4380f837896437cc9e8b076439c9ee17ea7993fa913d914c95022c72e373"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "32f354371ff14c9af5db6ccd0e22c20609b3ea0b8b5cef6cccda7d664e7b9171"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "de89c02b1654fa1a67c9d70bf9295218eda590fff370c01364ff2ebdc9c39c96"
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
