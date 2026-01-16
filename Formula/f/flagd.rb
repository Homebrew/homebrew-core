class Flagd < Formula
  desc "Feature flag daemon with a Unix philosophy"
  homepage "https://github.com/open-feature/flagd"
  url "https://github.com/open-feature/flagd.git",
      tag:      "flagd/v0.13.2",
      revision: "623e5e2ec8b24fa8c0c233aee47aa76839480b0b"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e369b2c7b718b551961310f06ac0e023e68b3a6b619a193502bef5427358e60a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "085f7d435a4b455aadf5cefe005cd4be215f6e7af644126353d3e34e1ac75d88"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e48832f16926f7ea27bd22610ff7cab667bb981784c815b092e8282657085331"
    sha256 cellar: :any_skip_relocation, sonoma:        "50227b3db04ab14637c2e982da4781680368677aeade2ad75a25dd190f350c53"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "eceb613f0c6acf23133d4c9fa8b3086d5abf57bacba432dbdcd1be2601716c4b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f55b0ec336faafff46a815b6bd1df3315395911f26045fb9abae9c130edddb26"
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
