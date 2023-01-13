class Flagd < Formula
  desc "Feature flag daemon with a Unix philosophy"
  homepage "https://github.com/open-feature/flagd"
  url "https://github.com/open-feature/flagd.git",
      tag:      "v0.3.1",
      revision: "7a1b1ef9b5c57b201612a49d3fa0d7405d421dc4"
  license "Apache-2.0"
  head "https://github.com/open-feature/flagd.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "074d1344006a7ca428a7b3651542984643ae0b3baba2f554b6d1b4a8349b9232"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "195240e2954bf8d03c689c434e061f293308bc9c5a333e033e265f317e6a7cfa"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c9451baa79b2ccffdf7dc842bb037bb55aa063ad2710f927f60bbad1d15ad5cd"
    sha256 cellar: :any_skip_relocation, ventura:        "ddab89b5438c62bb4bf96d335476ea1dd4b14a639cdee8d7619b3714ab7d9686"
    sha256 cellar: :any_skip_relocation, monterey:       "c84b8b2ff509b4aa2f683237a729ee4c8d8261da8186bcf6398e46375faa82bb"
    sha256 cellar: :any_skip_relocation, big_sur:        "b4f045420e67865a5eb8f0eecfe8665110c369c53261af189b6abdb56555508f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f6042f22d1d3d5652f4879e8cc06565cf9fdafa0b57de1ac33d6743c94714847"
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
