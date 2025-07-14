class Flagd < Formula
  desc "Feature flag daemon with a Unix philosophy"
  homepage "https://github.com/open-feature/flagd"
  url "https://github.com/open-feature/flagd.git",
      tag:      "flagd/v0.12.5",
      revision: "23e15540a737265c1244e4bf7ddcf04a9c5c60af"
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

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "89fcdf347ff89ad6523896f13caa2c631e88b5950f23a59422d127ef90e84f09"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "715f588ee2e41625f928b1f1ffe602ebae636f93da2087987665e655cab166e9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0dca190752fb6cd11e4a820a219c26e9260f9129fd83b47744aa8f1455925fae"
    sha256 cellar: :any_skip_relocation, sonoma:        "58c466f59438c7000e6762e6b3c5e911144feac0adc149d14c8259d4e524fa87"
    sha256 cellar: :any_skip_relocation, ventura:       "b93a8fec44b9e4346c77a71844e8b77fdbe2404827bb77e498b0f2e42987a5fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9ccfa9a1d4a76f3cbf692f3a868832a7373be78ffd2a019fe4fd7a4a9bb1de88"
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
