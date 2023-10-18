class Flagd < Formula
  desc "Feature flag daemon with a Unix philosophy"
  homepage "https://github.com/open-feature/flagd"
  url "https://github.com/open-feature/flagd.git",
      tag:      "flagd/v0.6.7",
      revision: "3dd69297c4dcf87f4780432600903fd3f76916fb"
  license "Apache-2.0"
  head "https://github.com/open-feature/flagd.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8841bd3e14b0c16f9a4f96b25d8d06214322c9286d88703d2229b353551dbcbf"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1f917e0c7d5901d3805ffdf1c2e6aee0e07f02accca35d87eac3e160495e48d2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "93e42ce883814fbe75a1473393b73feda4935937f6be359c4737328311bb6483"
    sha256 cellar: :any_skip_relocation, sonoma:         "bedbd0e392bb42830bf4c4cf334833a4fd1eaf42e6e755e7f18cd6f78aee650a"
    sha256 cellar: :any_skip_relocation, ventura:        "789b5ab30544cac4fb69472891ac1a2b15d79a4ee9765a028a26769cd4cae3d6"
    sha256 cellar: :any_skip_relocation, monterey:       "98ad88b2e6d5cd8d7300983c35d4a5f8eac8f3aef0d0ca78401edb57f2e07513"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "790f6ab4b08b1d8982e13791dcde6a88ea1da6db7d71dd68170b433a475ed93f"
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
