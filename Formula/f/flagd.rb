class Flagd < Formula
  desc "Feature flag daemon with a Unix philosophy"
  homepage "https://github.com/open-feature/flagd"
  url "https://github.com/open-feature/flagd.git",
      tag:      "flagd/v0.6.3",
      revision: "bf74c5a3fc1b52108c2b057b3680576a90f31453"
  license "Apache-2.0"
  head "https://github.com/open-feature/flagd.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9dda9eee7eb68884170dfcaef6c7a1a2fc47bd58c893c0e9130ab9ace3fee1e1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9dda9eee7eb68884170dfcaef6c7a1a2fc47bd58c893c0e9130ab9ace3fee1e1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9dda9eee7eb68884170dfcaef6c7a1a2fc47bd58c893c0e9130ab9ace3fee1e1"
    sha256 cellar: :any_skip_relocation, ventura:        "f473a2a75e743cc1834c1f29afe2bf3fbaf388b4f8196547a8c4db4be6480a9f"
    sha256 cellar: :any_skip_relocation, monterey:       "f473a2a75e743cc1834c1f29afe2bf3fbaf388b4f8196547a8c4db4be6480a9f"
    sha256 cellar: :any_skip_relocation, big_sur:        "f473a2a75e743cc1834c1f29afe2bf3fbaf388b4f8196547a8c4db4be6480a9f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b4328bd77ae1b042e474b83cb3cceec0ee531897b91306df71ed27ed41086be3"
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
