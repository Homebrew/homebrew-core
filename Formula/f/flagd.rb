class Flagd < Formula
  desc "Feature flag daemon with a Unix philosophy"
  homepage "https://github.com/open-feature/flagd"
  url "https://github.com/open-feature/flagd.git",
      tag:      "flagd/v0.9.1",
      revision: "b755a643bdfb87c4fbf67e275af41f5f04073944"
  license "Apache-2.0"
  head "https://github.com/open-feature/flagd.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a73b28d941ee0453ff322ecf7b5cbce160be9ccc4ef192a6da2498b2396db4c7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "46d44641dfc4cdaf739f471c1bf34cf588a6e30a8ad86540d42627edeab6210e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7c6612c32f249868bff44821f7d60b8359f3941a5ebb048a6cfcdeb4e7986416"
    sha256 cellar: :any_skip_relocation, sonoma:         "e67e383aae26c81476f37ee62d2862878b1663ddddd095d2c2ab7039b2a12497"
    sha256 cellar: :any_skip_relocation, ventura:        "ab81e83a42abf28f70e55a604e00397bf017cb3ea22cdc67680d42965ce046fa"
    sha256 cellar: :any_skip_relocation, monterey:       "373659ab7e256f63ad24d909edf0e8941428b3064f8f9cee7bda77c310bbbcdb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "21b211a20063d0b7b51c76ccacdc7f5a4c1bdac195653a5d9942f3a4c049e0e8"
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
    system "go", "build", *std_go_args(ldflags:), "./flagd/main.go"
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
