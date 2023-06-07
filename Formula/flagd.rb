class Flagd < Formula
  desc "Feature flag daemon with a Unix philosophy"
  homepage "https://github.com/open-feature/flagd"
  url "https://github.com/open-feature/flagd.git",
      tag:      "flagd/v0.5.4",
      revision: "f3fbe6dc6f260caf0dd25737b0caeb46deaf3e0a"
  license "Apache-2.0"
  head "https://github.com/open-feature/flagd.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "75ae935c79cae756087369afaa42edcffac5533732c13c5f9c3deea553b9261d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "75ae935c79cae756087369afaa42edcffac5533732c13c5f9c3deea553b9261d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "75ae935c79cae756087369afaa42edcffac5533732c13c5f9c3deea553b9261d"
    sha256 cellar: :any_skip_relocation, ventura:        "0f5c28bd8c14b8d510b0111f1cf42565a27f0f2fa3fea0189755cc271238f9cb"
    sha256 cellar: :any_skip_relocation, monterey:       "0f5c28bd8c14b8d510b0111f1cf42565a27f0f2fa3fea0189755cc271238f9cb"
    sha256 cellar: :any_skip_relocation, big_sur:        "0f5c28bd8c14b8d510b0111f1cf42565a27f0f2fa3fea0189755cc271238f9cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3547b587cedc035b5e1ddd123819c5d49cfa938118cfe0e7381947bbe0f4602c"
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
