class Flagd < Formula
  desc "Feature flag daemon with a Unix philosophy"
  homepage "https://flagd.dev"
  url "https://github.com/open-feature/flagd.git",
      tag:      "flagd/v0.16.3",
      revision: "c643e5f033f64b2e192ad871133582a62069c568"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "1902541851dedaf8841cefd36f971a4eae4e6fb0a1884d5a61b202727a9de793"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "214cd430141c28c55a454c22751db046d5e5566429ad4e14be428222be4d0020"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "19376055e61121c2e19e937705f646d10899e461fcd51add9280ce6b6a2b9f05"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "2a8e9b8e303bafa5a639ecd3756430c23ff65d078976515e7eac527874d7c643"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "7cffdeb70f7aff7b9b5c809a34acd7f39e3030b1712e2a5a5cecc2997d8e9b59"
    sha256 cellar: :any,                 x86_64_linux:      "ac0b0943b7a9763bb75f11b39c7153a7cfd549d5234255e4c3909b77773385ef"
  end

  depends_on "go" => :build

  def install
    ENV["GOPRIVATE"] = "buf.build/gen/go"
    ldflags = %W[
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
