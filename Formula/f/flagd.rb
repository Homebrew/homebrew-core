class Flagd < Formula
  desc "Feature flag daemon with a Unix philosophy"
  homepage "https://github.com/open-feature/flagd"
  url "https://github.com/open-feature/flagd.git",
      tag:      "flagd/v0.9.1",
      revision: "b755a643bdfb87c4fbf67e275af41f5f04073944"
  license "Apache-2.0"
  head "https://github.com/open-feature/flagd.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ed4098bf9af739fb6036d28f46dd3e050dff7e3aad0f1a5b7960da59caf9745a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d6705d302db6e8e4776d58818f95cc8b3720c393746d0a7e990ac6ed50b17854"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9278f6a6eea130f927b367c4c8ac15a54147b5fb02e9a96ee057774175fe6681"
    sha256 cellar: :any_skip_relocation, sonoma:         "3fa66e271ed81a2c23044b8fa184ac5e49540e1d67df9898a0cdac7b1653c482"
    sha256 cellar: :any_skip_relocation, ventura:        "f49d47bf9106906c754eed1000d567fe4e9b59217145a3690756e7bb13ca32e3"
    sha256 cellar: :any_skip_relocation, monterey:       "955ad353c63db5f619f7078bf2413f87e16be91d7189ca526e2d1e84d801b22a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "01ae3c2e25a58cc32f4aaa5dd958869093bd56c38f10354b00ac39557245b9b1"
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
