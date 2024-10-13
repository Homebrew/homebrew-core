class Flagd < Formula
  desc "Feature flag daemon with a Unix philosophy"
  homepage "https://github.com/open-feature/flagd"
  url "https://github.com/open-feature/flagd.git",
      tag:      "flagd/v0.11.3",
      revision: "851b9da43648bfb1695c682b1c1c588c749a71c9"
  license "Apache-2.0"
  head "https://github.com/open-feature/flagd.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9af3d31ffa2e69453f57f2684bee44c8029fd86bb9d2abe274c94187b19371b6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9af3d31ffa2e69453f57f2684bee44c8029fd86bb9d2abe274c94187b19371b6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9af3d31ffa2e69453f57f2684bee44c8029fd86bb9d2abe274c94187b19371b6"
    sha256 cellar: :any_skip_relocation, sonoma:        "36c70e2b7e71c770d43ee110e6d257321f71681e68bdc8915e0388fb15b0d4d7"
    sha256 cellar: :any_skip_relocation, ventura:       "36c70e2b7e71c770d43ee110e6d257321f71681e68bdc8915e0388fb15b0d4d7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "34fbad941da8c405021341a709ccfa2dbb6119220b69f9cc1d4b544b033862ff"
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
