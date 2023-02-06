class Flagd < Formula
  desc "Feature flag daemon with a Unix philosophy"
  homepage "https://github.com/open-feature/flagd"
  url "https://github.com/open-feature/flagd.git",
      tag:      "v0.3.6",
      revision: "79ac2f61b07170af6ae3509986b8e4b600a8681b"
  license "Apache-2.0"
  head "https://github.com/open-feature/flagd.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0784f05c401a4eb993fc8eeaacea77deee48b27ea79eb3deb338f42660a5e16f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3b01c6c74a5735495ab3fc25d127944718db69fa6110a1fe87135129f1b45c34"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "10ffb838b80958d1bca792fee3b644c76a00c668ce2a3c53a6284f4ee93d2f25"
    sha256 cellar: :any_skip_relocation, ventura:        "966b365045b3cefb2e4b608f099d759d8715d4d03c54eb1ddcc76c3abd6747d2"
    sha256 cellar: :any_skip_relocation, monterey:       "f6d6f4e04c764d391519cf4e467d0b42e975d653c7955952399c855d6ef4b011"
    sha256 cellar: :any_skip_relocation, big_sur:        "637338258e9848fb5ada6020df1c99f8a2540db92b4bfc7456fbad41d671f67c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "31583643ae5a0ce1057793b21ea4e4e8da007935bb4ba654e0c6c781558144c5"
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

    system "go", "build", *std_go_args(ldflags: ldflags)
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
