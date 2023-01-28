class Flagd < Formula
  desc "Feature flag daemon with a Unix philosophy"
  homepage "https://github.com/open-feature/flagd"
  url "https://github.com/open-feature/flagd.git",
      tag:      "v0.3.4",
      revision: "311cb92fc205fcaf0cab4773ea7f8c53bf63cc86"
  license "Apache-2.0"
  head "https://github.com/open-feature/flagd.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "17ad2e50edd07c8fdb1c590f0515edec5ff7667c41704c9bc3e2b92dfba01dd2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9abdc809f21debb110e2376831b6fd88061afab7cfee60467ae401024f7244e3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5a21b7a73b7083cbb9be06a022299823812c4a7c6a903d867d39e00d04d924a2"
    sha256 cellar: :any_skip_relocation, ventura:        "4e8d22a7d7aac39d3f9d2df60f58b6f7797fef581583ffd0e5b67c8203f90c51"
    sha256 cellar: :any_skip_relocation, monterey:       "b8407dd6eec41dcd14ab8c7562381ae3916e0bb1c0d4fa911544cf92c1dd9875"
    sha256 cellar: :any_skip_relocation, big_sur:        "3ad32437a2058e568b1ebba9a33bb4b15ff5f07bd41cc54ae11b4f9ee73fb6f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1f93383c9f374e871e978b8f458a81c507f3093bebafccea8b14d6c4dcb5dbe6"
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
