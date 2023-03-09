class Flagd < Formula
  desc "Feature flag daemon with a Unix philosophy"
  homepage "https://github.com/open-feature/flagd"
  url "https://github.com/open-feature/flagd.git",
      tag:      "v0.4.2",
      revision: "5dad8ada4dd981b13cc7640d55ccb6e4cab02295"
  license "Apache-2.0"
  head "https://github.com/open-feature/flagd.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4bec9f59f8e1b59bef0deeb2b8b5c275128b995971b0df28e4ae65ceff61f74f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7eaae1665ac44ea6327b753701c828abc8c1361af12ae0bce6e2e4075eec31b4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4bec9f59f8e1b59bef0deeb2b8b5c275128b995971b0df28e4ae65ceff61f74f"
    sha256 cellar: :any_skip_relocation, ventura:        "35df4735455b853017d560336c6495c7ee2787af3c805e54efc8031f0e8c1299"
    sha256 cellar: :any_skip_relocation, monterey:       "f7f7e251b137eb58fbf1eb53379a740889b60ee471d87b189907dfd7ce8373e7"
    sha256 cellar: :any_skip_relocation, big_sur:        "35df4735455b853017d560336c6495c7ee2787af3c805e54efc8031f0e8c1299"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "45541ab7415f40b5566b1315d2b14163b9ca8ef4d1dc6b758bbd356324437a0f"
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
