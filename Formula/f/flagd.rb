class Flagd < Formula
  desc "Feature flag daemon with a Unix philosophy"
  homepage "https://github.com/open-feature/flagd"
  url "https://github.com/open-feature/flagd.git",
      tag:      "flagd/v0.15.1",
      revision: "18ad1db202aa5e623b99d53c5f1cc690d151e78c"
  license "Apache-2.0"
  head "https://github.com/open-feature/flagd.git", branch: "main"

  # The upstream repository contains tags like `core/v1.2.3`,
  # `flagd-proxy/v1.2.3`, etc. but we're only interested in the `flagd/v1.2.3`
  # tags. Upstream only appears to mark the `core/v1.2.3` releases as "latest"
  # and there isn't usually a notable gap between tag and release, so we check
  # the Git tags.
  livecheck do
    url :stable
    regex(%r{^flagd/v?(\d+(?:[.-]\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "abcce3fb7ff4e1c862855772558fe7b96a91db107a1d5044d8b70a2d08a982c9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dabc21b8f51cb2e190c749ee44c5a1efbe4e76739be4768ffd9117bcb7a8ea02"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "04ef577e37526cb81ed53894ad0db85c86eb512a824c2c7b9392aea13761ecfd"
    sha256 cellar: :any_skip_relocation, sonoma:        "9872842b77f30f30691e2c8e115429469f847fe760bb84158d24dd4615b0eafb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "674deff81e755cf64a1071b7c21bb947fc62ecaafac0be110d95d1aa7556af6a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e2e93810bf54b1d5f7659124cd9cb6b9eddc45e328358d110f3354593fd61ae0"
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
    generate_completions_from_executable(bin/"flagd", shell_parameter_format: :cobra)
  end

  test do
    port = free_port
    json_url = "https://raw.githubusercontent.com/open-feature/flagd/main/config/samples/example_flags.json"
    resolve_boolean_command = <<~BASH
      curl \
      --request POST \
      --data '{"flagKey":"myBoolFlag","context":{}}' \
      --header "Content-Type: application/json" \
      localhost:#{port}/schema.v1.Service/ResolveBoolean
    BASH

    pid = spawn bin/"flagd", "start", "-f", json_url, "-p", port.to_s
    begin
      sleep 3
      assert_match(/true/, shell_output(resolve_boolean_command))
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
