class Flagd < Formula
  desc "Feature flag daemon with a Unix philosophy"
  homepage "https://github.com/open-feature/flagd"
  url "https://github.com/open-feature/flagd.git",
      tag:      "flagd/v0.10.1",
      revision: "e1752badc2a68a230e8df4ac00fa0e4083ee0d58"
  license "Apache-2.0"
  head "https://github.com/open-feature/flagd.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6f09dec8e3a321c2f46b81d46128c95856cdb1e883e2594c6441f3322e4b32f8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ba954ef23d2a87bffb2b39613b612b95fd1cbd46b9a082ba97fbb439d435d9e0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "08db5bd60f03898bd59fc5e4bded3a9fc031b7a6e37ec6a11d5fe189492b6a19"
    sha256 cellar: :any_skip_relocation, sonoma:         "fecc1b74185884b9825019ebd8d7fdc34ed99d04e29f131e78802a83c4608241"
    sha256 cellar: :any_skip_relocation, ventura:        "1c68a342a63be97ddfe0df628cf53e842b5936391245d2add3f04c6f3ff75d73"
    sha256 cellar: :any_skip_relocation, monterey:       "a4ca4b6c6650bf295800683f9ea11b300b82dd43b74b24482e96cb45f841eed8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f8fdb3d56c511dfeb30e518d3bec2f77d69700c61d9405371740f1ecde489a8a"
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
