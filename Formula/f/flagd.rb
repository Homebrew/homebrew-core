class Flagd < Formula
  desc "Feature flag daemon with a Unix philosophy"
  homepage "https://github.com/open-feature/flagd"
  url "https://github.com/open-feature/flagd.git",
      tag:      "flagd/v0.14.3",
      revision: "6bd709c8beec61bbd2b2abea65a9477074c7aaa5"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "09440c0ad00f4e93a4a07670d9634620c75cb1159922476d3cf17dab9c3057eb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2c30b66654a921a53d01900fd085eeee612843e51f8e198920c0c106df8c8d0b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cc0556c2e8ffdb2906d008bfd65909251527653190efe90b1a1a62247e694d88"
    sha256 cellar: :any_skip_relocation, sonoma:        "c8dc62df1c699bd2c22a22bd9a40cd30bf81b08b5d40b29c823bc7d929c65cf1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b6470b4936ff4400f08e5e2b48715b10b4a5c265bae04017051fa489f525b197"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "66f589acafe3c52c68331ad8caeeba977c0ca3ce5ed1999d70db37ab3dc18ac4"
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
