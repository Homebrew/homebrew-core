class Flagd < Formula
  desc "Feature flag daemon with a Unix philosophy"
  homepage "https://github.com/open-feature/flagd"
  url "https://github.com/open-feature/flagd.git",
      tag:      "flagd/v0.11.7",
      revision: "600ce46d618cd9685fd0e736987941801fb07359"
  license "Apache-2.0"
  head "https://github.com/open-feature/flagd.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6225eecf3f437f485a49b184932467de886cfa3dc8435f52747be2a967d5b970"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6225eecf3f437f485a49b184932467de886cfa3dc8435f52747be2a967d5b970"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6225eecf3f437f485a49b184932467de886cfa3dc8435f52747be2a967d5b970"
    sha256 cellar: :any_skip_relocation, sonoma:        "d34829e21fcc9e201ebc7945f5d38a085cbad8b4cbe299d557dcc46eac3dcfb4"
    sha256 cellar: :any_skip_relocation, ventura:       "d34829e21fcc9e201ebc7945f5d38a085cbad8b4cbe299d557dcc46eac3dcfb4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "87127c1454655095e935962d56ea8554372a8071842a80be086b6d74fc0df3b4"
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
    json_url = "https://raw.githubusercontent.com/open-feature/flagd/main/config/samples/example_flags.json"
    resolve_boolean_command = <<~BASH
      curl \
      --request POST \
      --data '{"flagKey":"myBoolFlag","context":{}}' \
      --header "Content-Type: application/json" \
      localhost:#{port}/schema.v1.Service/ResolveBoolean
    BASH

    pid = spawn bin/"flagd", "start", "-f", json_url, "-p", port.to_s
    begin
      sleep 3
      assert_match(/true/, shell_output(resolve_boolean_command))
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
