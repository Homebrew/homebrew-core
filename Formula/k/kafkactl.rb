class Kafkactl < Formula
  desc "CLI for managing Apache Kafka"
  homepage "https://deviceinsight.github.io/kafkactl/"
  url "https://github.com/deviceinsight/kafkactl/archive/refs/tags/v5.9.0.tar.gz"
  sha256 "2ff3d87743ca25105154bfcd7047e4eb96c15a70d7e3f7224d3e318ccef468b7"
  license "Apache-2.0"
  head "https://github.com/deviceinsight/kafkactl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c0547b414b97eec5225acb7d6cd57e65d953e5699a86b1aabac98f49b802e624"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c0547b414b97eec5225acb7d6cd57e65d953e5699a86b1aabac98f49b802e624"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c0547b414b97eec5225acb7d6cd57e65d953e5699a86b1aabac98f49b802e624"
    sha256 cellar: :any_skip_relocation, sonoma:        "e0d3b04ea60e0b9629b0a90552a458bc8bb7471a89d2658f34f1ebe557625e6b"
    sha256 cellar: :any_skip_relocation, ventura:       "e0d3b04ea60e0b9629b0a90552a458bc8bb7471a89d2658f34f1ebe557625e6b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cd0ee312b375827b917a2e30054b67b556bf5423c4e2c2e9eb76815e84b0de9a"
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
