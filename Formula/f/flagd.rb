class Flagd < Formula
  desc "Feature flag daemon with a Unix philosophy"
  homepage "https://github.com/open-feature/flagd"
  url "https://github.com/open-feature/flagd.git",
      tag:      "flagd/v0.8.2",
      revision: "116ad362aaf6248c743f0d73f784fcf9fed1389c"
  license "Apache-2.0"
  head "https://github.com/open-feature/flagd.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8e1e740061d1681f2d4a5ace8dd61f7938dbfc2d4a912469bad12c5177651279"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "af56f07028eb031233ab915f644b4420595c0600aa1fbf62c9148e47d87c41d2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "11c42eac473ad12f1c3e66c2c52592600b36fbf478c5e9f5872f8397b52346f8"
    sha256 cellar: :any_skip_relocation, sonoma:         "3f27c114940df93c4723688697b65eea7209f1878cff71ef20cd4a021aa9131b"
    sha256 cellar: :any_skip_relocation, ventura:        "af6e5ebbeb2ba3d888fe376400b4b00147edde6d460238c95589252976ef035c"
    sha256 cellar: :any_skip_relocation, monterey:       "8bb26ec43b5a1414aacb470bddced55ee262f9bf737d5b95b57193c962daaf65"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "542b80f264bdd660a9ebb648661b46013d5451fc6d24a3e266080a35dec45158"
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
