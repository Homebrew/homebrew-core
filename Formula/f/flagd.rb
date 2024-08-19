class Flagd < Formula
  desc "Feature flag daemon with a Unix philosophy"
  homepage "https://github.com/open-feature/flagd"
  url "https://github.com/open-feature/flagd.git",
      tag:      "flagd/v0.11.1",
      revision: "9ac329f9206360e532d615904f977309b0af71a5"
  license "Apache-2.0"
  head "https://github.com/open-feature/flagd.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cf914d01b707a76ed1af6eca9c366c8aad497557760b039df59a6498e0ce1705"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9ce6b8b5121b6d4240e5aa7ff3e92d86ca07fb573e7ce57227090e0c51a75bef"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d9afebf75e54fe5615b04a9433526a8e8f7bcdc91d82dc4ebb0bd01b65540017"
    sha256 cellar: :any_skip_relocation, sonoma:         "222c8393332cdc032cf8c68bf2658cee72d0f435a00500d492fec98e06e14aa7"
    sha256 cellar: :any_skip_relocation, ventura:        "7d784b4cfd07f26d7081ad20f3e3960aef05f3d409b585c233f11513fc20c4f3"
    sha256 cellar: :any_skip_relocation, monterey:       "5974070e17039d6dc9070df3958784006f41d5e70bcdaa04ce3fbba0f49e1d72"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4bf7e24507121c32fd46a482333114e4f28177209ec1b5052a05c58b94a05051"
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
