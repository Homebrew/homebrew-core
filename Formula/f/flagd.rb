class Flagd < Formula
  desc "Feature flag daemon with a Unix philosophy"
  homepage "https://github.com/open-feature/flagd"
  url "https://github.com/open-feature/flagd.git",
      tag:      "flagd/v0.8.0",
      revision: "4711aaa0ec7560a3c226955b4e1626204fe7f759"
  license "Apache-2.0"
  head "https://github.com/open-feature/flagd.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "149db7957c99d2157d91d98737efea84037bb86c6f6fd05a27f8963b7ca070c3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bbc235aa6d5fe2df15716ab7d5175df4d4b47e2111161d2a4bd16cb83b59eb7d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0cdc33f81e28571a284772725ba989ac65057410baf335a13471f2454a10f854"
    sha256 cellar: :any_skip_relocation, sonoma:         "8fa27132b279c0f9ac56bbefbaaf67c1572ce2d1f4a73ffa95ddc588db05516b"
    sha256 cellar: :any_skip_relocation, ventura:        "cfcc8e3de8bc0e43d6d895a0a876dce1b49ee632a05c442001ae163614d2aad4"
    sha256 cellar: :any_skip_relocation, monterey:       "d869bf1bfacf57b66e5615fff639d99f4ea0fbfb71f2a988a3bebc41278c7701"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "250e515f9d6f1ab493c2105e9440b5cf981a4d6452692235c541483a41b44ced"
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
