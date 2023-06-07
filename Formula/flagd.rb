class Flagd < Formula
  desc "Feature flag daemon with a Unix philosophy"
  homepage "https://github.com/open-feature/flagd"
  url "https://github.com/open-feature/flagd.git",
      tag:      "flagd/v0.5.4",
      revision: "f3fbe6dc6f260caf0dd25737b0caeb46deaf3e0a"
  license "Apache-2.0"
  head "https://github.com/open-feature/flagd.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2e0c83fbb10eab81e400ebd6fd57d25d0df4620fe5bc914b3ea5f580bf560f8e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2e0c83fbb10eab81e400ebd6fd57d25d0df4620fe5bc914b3ea5f580bf560f8e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2e0c83fbb10eab81e400ebd6fd57d25d0df4620fe5bc914b3ea5f580bf560f8e"
    sha256 cellar: :any_skip_relocation, ventura:        "0f9991cb92cc2dc924c231871528379397db5d74e1d88475e20d8cee2fb9c857"
    sha256 cellar: :any_skip_relocation, monterey:       "0f9991cb92cc2dc924c231871528379397db5d74e1d88475e20d8cee2fb9c857"
    sha256 cellar: :any_skip_relocation, big_sur:        "0f9991cb92cc2dc924c231871528379397db5d74e1d88475e20d8cee2fb9c857"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eba50d6e4026972327e1b68f8127606806144701913f549e091e7234454eae95"
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
