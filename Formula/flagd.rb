class Flagd < Formula
  desc "Feature flag daemon with a Unix philosophy"
  homepage "https://github.com/open-feature/flagd"
  url "https://github.com/open-feature/flagd.git",
      tag:      "v0.3.5",
      revision: "e77950bf6e4c337671de745a4a500cb464649079"
  license "Apache-2.0"
  head "https://github.com/open-feature/flagd.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a6bd5aa4e456e727ef3bbca420fb33a7828c495f42fb2be49046b741db7c8167"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ba1a0c86d7421960c31a34b57559460ec4daf80fb83a6fef9948f82aaa10e1f4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "149548585ec530266bf1ac0b2b5797fe68fa086898ba6f1665e1fdb94fc2d120"
    sha256 cellar: :any_skip_relocation, ventura:        "b4ebd96f7b0cda5a7408625221bda3b696c9410382f8bab4cfa7894059b50c6a"
    sha256 cellar: :any_skip_relocation, monterey:       "ccb3a510d2e562ee39e6619a499c70b5f66fe07306973cf2e5b206fd82ebdc91"
    sha256 cellar: :any_skip_relocation, big_sur:        "fb03a59c86691fd94b77e919816cf8ee0617a00ac0a2ac6552a278f0590cc7ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b067410b38407537d33ec830865cb45b015a3415225d177fa34f769f5ff1d519"
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
