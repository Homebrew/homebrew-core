class Kafkactl < Formula
  desc "CLI for managing Apache Kafka"
  homepage "https://deviceinsight.github.io/kafkactl/"
  url "https://github.com/deviceinsight/kafkactl/archive/refs/tags/v5.10.1.tar.gz"
  sha256 "22b0d60aa8265a3520d961b07d58886b9266798c57fa41a05b74b19814819c4d"
  license "Apache-2.0"
  head "https://github.com/deviceinsight/kafkactl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "955ab818ee8f3426363d478180b2faa12314134c3716802ea0a90196b85f8704"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "955ab818ee8f3426363d478180b2faa12314134c3716802ea0a90196b85f8704"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "955ab818ee8f3426363d478180b2faa12314134c3716802ea0a90196b85f8704"
    sha256 cellar: :any_skip_relocation, sonoma:        "b376b4703fc0a8d34007afd7754a445425d13f10b99ade491d0d70ba3415bac0"
    sha256 cellar: :any_skip_relocation, ventura:       "b376b4703fc0a8d34007afd7754a445425d13f10b99ade491d0d70ba3415bac0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fc6e84feabb05ee22bd80e932d8eb48f75c89b3ebc18e902b69a6c02631cbcbb"
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
