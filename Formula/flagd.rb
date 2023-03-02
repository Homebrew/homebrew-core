class Flagd < Formula
  desc "Feature flag daemon with a Unix philosophy"
  homepage "https://github.com/open-feature/flagd"
  url "https://github.com/open-feature/flagd.git",
      tag:      "v0.4.0",
      revision: "408bb7c6420678706854932df3144253ada89f82"
  license "Apache-2.0"
  head "https://github.com/open-feature/flagd.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "79d926690fd523768a4cddc6ba6d81f9aa40f94d693d46c0392124b913383311"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cb944af79a884e1093659b12dffe0d2d41ea2900b886225c17805566c69c26ea"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4000f2458bc74fd6a2089e111ce4c413578ca0dcf73e80ee5621a6fb40210416"
    sha256 cellar: :any_skip_relocation, ventura:        "5d3b59c445d611b5411589e5de28d4a98797a5b3d2bf6057c4915113340269aa"
    sha256 cellar: :any_skip_relocation, monterey:       "6f63ab490c9291398e76e955c8e185d4da48d2218ee8bc00c88a1503406628b3"
    sha256 cellar: :any_skip_relocation, big_sur:        "87dcd247b6858ea42bec809b05945ae635fa663729ffe4b2fc64d9e78c3dc49d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "29f3c1cef3633d7c44706729ad21a9c78057c3530244df81d9f5848963c8dbb2"
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
