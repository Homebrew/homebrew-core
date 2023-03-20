class Flagd < Formula
  desc "Feature flag daemon with a Unix philosophy"
  homepage "https://github.com/open-feature/flagd"
  url "https://github.com/open-feature/flagd.git",
      tag:      "flagd/v0.4.4",
      revision: "873c7b37dbbfefa8f6448fb1dec06b2ce40fb02d"
  license "Apache-2.0"
  head "https://github.com/open-feature/flagd.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b3b51741d4d1361d92f76e667583696f6ca371954e7f07ec504b89857acc2d92"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b8bb753f87767f133803dc93340f19da386000f1243c3e8e749a6076f0f2706c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b3b51741d4d1361d92f76e667583696f6ca371954e7f07ec504b89857acc2d92"
    sha256 cellar: :any_skip_relocation, ventura:        "0c62a0b82373cb8a124c11647a4a513a683a7cf097e2b270ae88ee55631a1952"
    sha256 cellar: :any_skip_relocation, monterey:       "0c62a0b82373cb8a124c11647a4a513a683a7cf097e2b270ae88ee55631a1952"
    sha256 cellar: :any_skip_relocation, big_sur:        "0c62a0b82373cb8a124c11647a4a513a683a7cf097e2b270ae88ee55631a1952"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6559c6212fa3bc24906c9c10525524992e5e8c5d21d9d2773b04900339a35350"
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
