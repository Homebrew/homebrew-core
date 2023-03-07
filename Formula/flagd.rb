class Flagd < Formula
  desc "Feature flag daemon with a Unix philosophy"
  homepage "https://github.com/open-feature/flagd"
  url "https://github.com/open-feature/flagd.git",
      tag:      "v0.4.1",
      revision: "4e904a2d77c8c2fe05d7a42ecb306ed12d9884e6"
  license "Apache-2.0"
  head "https://github.com/open-feature/flagd.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "60e480e2a3d7f585e1b294336847d54546bcc2af40df1493de0cb1c9aa02fd45"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c649bbec56f41ed69e91799e6cf68f824d2f3a25cd319877863f4c40ffc81756"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "60e480e2a3d7f585e1b294336847d54546bcc2af40df1493de0cb1c9aa02fd45"
    sha256 cellar: :any_skip_relocation, ventura:        "a1cf4d0ab9061ee1816d7a16591ee3952506f9552d6b4d820ce469814c38713b"
    sha256 cellar: :any_skip_relocation, monterey:       "2f09da6688fdaced88792a2d64715d0cd2867d3c50973299d4c97f83f60e5481"
    sha256 cellar: :any_skip_relocation, big_sur:        "a1cf4d0ab9061ee1816d7a16591ee3952506f9552d6b4d820ce469814c38713b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "325aa508a5021c51c2485e18bb82daa08020b6ccabf7db5d02b16f050c09d955"
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
