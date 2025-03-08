class Kafkactl < Formula
  desc "CLI for managing Apache Kafka"
  homepage "https://deviceinsight.github.io/kafkactl/"
  url "https://github.com/deviceinsight/kafkactl/archive/refs/tags/v5.5.1.tar.gz"
  sha256 "8bb984f5d0026dd7a474dfc259b3ac0a271983861aeb5ff770e74503ee019397"
  license "Apache-2.0"
  head "https://github.com/deviceinsight/kafkactl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "55c115ed882b514512f24751419fcdf8d234d1f73eb8e51174b0eebf13d62a80"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "55c115ed882b514512f24751419fcdf8d234d1f73eb8e51174b0eebf13d62a80"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "55c115ed882b514512f24751419fcdf8d234d1f73eb8e51174b0eebf13d62a80"
    sha256 cellar: :any_skip_relocation, sonoma:        "aa246966a576b4d4d52c83884f4acc3a744ee5fbdefa667262b4481407ac5eea"
    sha256 cellar: :any_skip_relocation, ventura:       "aa246966a576b4d4d52c83884f4acc3a744ee5fbdefa667262b4481407ac5eea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ecb3fe1c677ac0382640c978babfdad7614c1d7c97f6383ff9b0d3f1fdc3380c"
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
