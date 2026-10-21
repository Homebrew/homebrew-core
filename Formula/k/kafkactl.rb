class Kafkactl < Formula
  desc "CLI for managing Apache Kafka"
  homepage "https://deviceinsight.github.io/kafkactl/"
  url "https://github.com/deviceinsight/kafkactl/archive/refs/tags/v5.21.0.tar.gz"
  sha256 "31baacbaab41a9b3f945a894440b11647b99e1dd49744ccfa750aa082fb4632e"
  license "Apache-2.0"
  head "https://github.com/deviceinsight/kafkactl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b7d06f2fa80e91143c41a1ae9777f48ca9205769f6552fe505f1b96519bd6554"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b7d06f2fa80e91143c41a1ae9777f48ca9205769f6552fe505f1b96519bd6554"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b7d06f2fa80e91143c41a1ae9777f48ca9205769f6552fe505f1b96519bd6554"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "2fcb9d9743fda85f10df4bb6590b3942bef045d1bcdd29524e0d6eaf73c56396"
    sha256 cellar: :any,                 x86_64_linux:      "1d17274a6b484aa0132382398c92f30b4a154d9314617353d7a308a32dcc3f6c"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

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
