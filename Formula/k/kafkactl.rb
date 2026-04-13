class Kafkactl < Formula
  desc "CLI for managing Apache Kafka"
  homepage "https://deviceinsight.github.io/kafkactl/"
  url "https://github.com/deviceinsight/kafkactl/archive/refs/tags/v5.18.0.tar.gz"
  sha256 "f07b27c973412651dc35fc09e0db8644da0575e1293f1c85689feda19d917ef0"
  license "Apache-2.0"
  head "https://github.com/deviceinsight/kafkactl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4281fec8deef02f0999cf85c76239496d84e6f2bc570e8fc78dc5a1fbe424665"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4281fec8deef02f0999cf85c76239496d84e6f2bc570e8fc78dc5a1fbe424665"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4281fec8deef02f0999cf85c76239496d84e6f2bc570e8fc78dc5a1fbe424665"
    sha256 cellar: :any_skip_relocation, sonoma:        "cf2c04d06546043f4e4079e480d7e3a48f12c4a0f14e98c8df47f8f24f075eb2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "45730352148fd6b5d21fec66f97339eb49d7886d78ccf244ea77013ffefbd8e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "36cfecee236a47e0abfbdfb126edb31a6d5cf5fc1223e9c78d96eeda132ce09d"
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
