class Flagd < Formula
  desc "Feature flag daemon with a Unix philosophy"
  homepage "https://github.com/open-feature/flagd"
  url "https://github.com/open-feature/flagd.git",
      tag:      "flagd/v0.6.6",
      revision: "90152efa005b1e7881c496c71dd1b7adfa4eeb1a"
  license "Apache-2.0"
  head "https://github.com/open-feature/flagd.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3f6abd0eab6781d9a16681aacfa256b0ffe33c430fc3c2f0afb0fb11a9a2be4a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5935b87b1bab548850485d16789bbb20e9cf4f39eead083a92829785753a7441"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d89aed9f6c93928a22b4c9b5797337ae93dbfb38bc482b6ae70bcd1e78c525dc"
    sha256 cellar: :any_skip_relocation, ventura:        "02b0db9ac01cfd7c71bac26f48c51fa1a29c09e05b34bee31cac26657c27d8f2"
    sha256 cellar: :any_skip_relocation, monterey:       "b7ffcdefe5e637bfd96b54221581bfbfd9a2fc0f68db5d1cedc3a3032fa5ecf0"
    sha256 cellar: :any_skip_relocation, big_sur:        "23deca44df7e113d78f5a72c64a61bcb02a836d7470a8f56bb313f74a35cad16"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c7752dee6899ebfe0b985488e4582abd4e08a1a1151f55aaad8640e4d6c59ce9"
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
