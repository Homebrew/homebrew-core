class Flagd < Formula
  desc "Feature flag daemon with a Unix philosophy"
  homepage "https://flagd.dev"
  url "https://github.com/open-feature/flagd.git",
      tag:      "flagd/v0.19.0",
      revision: "11037220611eab982261d2348b13147b4450b562"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "4bd434c992a08ed2c9e1333f372ef4ca775c3983497e1a57094790d0fbc9ffa2"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "4325693a58531b01d95c3b56619a3b41981db8e4c6a7be65cf5e2a59001c40f5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e300ebbf405990ddf36b748aaed03fd4bd9c87ef60a7dd75bc0366e763c4f52f"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "dd6a8a7be6633347a1cb6c3d217b88812573e300fbd45db952542b60d82f558c"
    sha256 cellar: :any,                 x86_64_linux:      "dc6c2eee84cd86cb5678534ae221dd79af3e31afbca0c961fb51ba0f70dd4690"
  end

  depends_on "go" => :build

  # `test do` block runs a local flagd server with flags from a remote URL
  allow_network_access! :test

  def fetch
    ENV["GOPRIVATE"] = "buf.build/gen/go"
    system "make", "workspace-init"
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
      -X main.version=#{version}
      -X main.commit=#{Utils.git_head}
      -X main.date=#{time.iso8601}
    ]

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

    with_test_process(bin/"flagd", "start", "-f", json_url, "-p", port.to_s) do
      sleep 3
      assert_match(/true/, shell_output(resolve_boolean_command))
    end
  end
end
