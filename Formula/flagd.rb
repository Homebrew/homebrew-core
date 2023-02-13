class Flagd < Formula
  desc "Feature flag daemon with a Unix philosophy"
  homepage "https://github.com/open-feature/flagd"
  url "https://github.com/open-feature/flagd.git",
      tag:      "v0.3.7",
      revision: "b71729ae8b06998a9ff9b68c628ad16727bb1033"
  license "Apache-2.0"
  head "https://github.com/open-feature/flagd.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d588c0101073cf7bf6fb54fd1e2c03f958f88f8d9a2f550301e04f0cc9c9f8a0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cf87f0b1c4e0595f9a2b35e39fa7e1837f99f30f1d43ecf2693a253daea91277"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "16459a6094d23ead4be505fdf0b90c20ca9974f0e22f98e8e20fd4ef1c34c2b5"
    sha256 cellar: :any_skip_relocation, ventura:        "1bf26ec27dc749a977646f5f2a461d056aa58501c75c5028dc8071d39df2c304"
    sha256 cellar: :any_skip_relocation, monterey:       "92fbebb9c4b5e2650d98fa0b621debb0e3762c4b48ea0394c0712f2adc0c1185"
    sha256 cellar: :any_skip_relocation, big_sur:        "d4fbadbb14015defe75199dac0c199e40f33e2978849bcb62326b2dab3908eeb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "526cb5d541e064624f15b77045b968bf6074c39b68db999360cc8baea54a718a"
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
