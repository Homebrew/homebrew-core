class Flagd < Formula
  desc "Feature flag daemon with a Unix philosophy"
  homepage "https://flagd.dev"
  url "https://github.com/open-feature/flagd.git",
      tag:      "flagd/v0.18.0",
      revision: "ac826d8e9cf3f5b14ad56f6e9eeeb981f45321eb"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "aa0fb6abc969f468e0f79a98650d39a4ab964faadcc8f4595ebefda24118abd9"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "87eb57f28ea733496dc9ed639f99c186ed45fff1610d71322da404770ffd7861"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "31809e2d2332529bfc1ffd94e0df49f4732688eea4aa767abe1103db2b69a69d"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "66ad38d7d1e4a53418fb6459c0f6c20d2dbd5a98c19abc5bc39564fb5e7fbb04"
    sha256 cellar: :any,                 x86_64_linux:      "023eda1410d7568ed4ec881878a865affac08e2d092c761a3e585578b742bdf2"
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
