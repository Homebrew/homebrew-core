class Flagd < Formula
  desc "Feature flag daemon with a Unix philosophy"
  homepage "https://github.com/open-feature/flagd"
  url "https://github.com/open-feature/flagd.git",
      tag:      "flagd/v0.5.2",
      revision: "0fbd30f4b3ba25d3e8adf457d2708cd0990b68d8"
  license "Apache-2.0"
  head "https://github.com/open-feature/flagd.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1645545eb3587526a11a403c0896a5e9ee2bc21d81f3b663527abdf1dd41e4cc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9105729ca7143eeeb707120270c0c3e3ff4e52a7d51acf0d80ea0dd3224095c6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1645545eb3587526a11a403c0896a5e9ee2bc21d81f3b663527abdf1dd41e4cc"
    sha256 cellar: :any_skip_relocation, ventura:        "99f5d85a1bee881ecc5d2f9732ff38d3c49aad44bc01958fb384d731dde4b773"
    sha256 cellar: :any_skip_relocation, monterey:       "59b30ee5f670c25159a2911e435056bf03185d700533b87988434d77fcfce4ea"
    sha256 cellar: :any_skip_relocation, big_sur:        "59b30ee5f670c25159a2911e435056bf03185d700533b87988434d77fcfce4ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3c41c11933dbfe4ec986405d63dc75810db4fa50671804dcca7d7f986d7c44bf"
  end

  depends_on "go" => :build

  def install
    ENV["GOPRIVATE"] = "buf.build/gen/go"
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{Utils.git_head}
      -X main.date=#{time.iso8601}
    ]

    system "make", "workspace-init"
    system "go", "build", *std_go_args(ldflags: ldflags), "./flagd/main.go"
    generate_completions_from_executable(bin/"flagd", "completion")
  end

  test do
    port = free_port

    begin
      pid = fork do
        exec bin/"flagd", "start", "-f",
            "https://raw.githubusercontent.com/open-feature/flagd/main/config/samples/example_flags.json",
            "-p", port.to_s
      end
      sleep 3

      resolve_boolean_command = <<-BASH
        curl -X POST "localhost:#{port}/schema.v1.Service/ResolveBoolean" -d '{"flagKey":"myBoolFlag","context":{}}' -H "Content-Type: application/json"
      BASH

      expected_output = /true/

      assert_match expected_output, shell_output(resolve_boolean_command)
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
