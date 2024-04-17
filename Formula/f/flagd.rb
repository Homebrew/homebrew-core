class Flagd < Formula
  desc "Feature flag daemon with a Unix philosophy"
  homepage "https://github.com/open-feature/flagd"
  url "https://github.com/open-feature/flagd.git",
      tag:      "flagd/v0.10.0",
      revision: "584a469d08ea74c8916c43c1a2fd292c7e648dcd"
  license "Apache-2.0"
  head "https://github.com/open-feature/flagd.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "707cd18ecc0ba821fb39eaf5b4f8f28b151e048e5650c1561a2382becc2668f5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1b98004e40fddeae8865eed3c6e4528e9318f729c819294874585bc3b1965927"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "61387c3481b0313d250720e10f10e7d44bd04ae34e5c6195e5fce6305d904b91"
    sha256 cellar: :any_skip_relocation, sonoma:         "7698bb21e31b0cab3fb9b866b0bfbee457d262ad58117b2b59fe1eb9d0781fc7"
    sha256 cellar: :any_skip_relocation, ventura:        "e349081686aab0092dc32367904e2f3fcdd4bee3c450ebbc41e91d17c27b4cdf"
    sha256 cellar: :any_skip_relocation, monterey:       "95aff2cdc180c4ce552f99d0b2a5ed78cc9b5ad49e35a6104bd0557a3e6f641e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1815403e22877bcb692abb0701b06947eee7acc9e828d70958e70dbacdb821b8"
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
