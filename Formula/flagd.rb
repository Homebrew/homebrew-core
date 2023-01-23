class Flagd < Formula
  desc "Feature flag daemon with a Unix philosophy"
  homepage "https://github.com/open-feature/flagd"
  url "https://github.com/open-feature/flagd.git",
      tag:      "v0.3.1",
      revision: "7a1b1ef9b5c57b201612a49d3fa0d7405d421dc4"
  license "Apache-2.0"
  head "https://github.com/open-feature/flagd.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0c8558056f046cb8ef92164e533797e750c8eb9cca05f39442cbd71a8a6495b9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ff1113e52f67bbbd990b182f63e648253ab510f345055551e371601687012d36"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "14b98a4819c56cb2a3f120cccf0d0d51de90c5be3357dde892d13194bbc64e64"
    sha256 cellar: :any_skip_relocation, ventura:        "003bed88ded1e4fab06c321f9ea06dc53f1b870417f1cd06dc7e21624d4265fd"
    sha256 cellar: :any_skip_relocation, monterey:       "bff1b50e6c7a4166232d4c928b46566755442b0d7a90c024623d40752940994a"
    sha256 cellar: :any_skip_relocation, big_sur:        "d6de24f991faccd3ea293247a5b010f9c3fc39cf4c2b35de3eeaa89b6500820f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cc288a6507b82929a822b25790d203c8b1925ce6c1cc25b9b3d50caeb68d2f78"
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
