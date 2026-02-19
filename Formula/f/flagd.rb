class Flagd < Formula
  desc "Feature flag daemon with a Unix philosophy"
  homepage "https://github.com/open-feature/flagd"
  url "https://github.com/open-feature/flagd.git",
      tag:      "flagd/v0.13.3",
      revision: "47f904b3a5a5a6e4389de6201bef3c15158dbc97"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f228743f87ee325dca3e750594437c759e6d02dd6ad5feed528be84b65383765"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6d47f362d9502ec49bde328ac99615dedc378ab47fab800808f35f6c27c0e548"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7141116ea1263726d86853086cddb21bed2af2e9eccd87384c2e2ef4c4becfb6"
    sha256 cellar: :any_skip_relocation, sonoma:        "b461987a57d855a08098187d95fd29e31606dd0fae3611e23024a5e3dd4d4a5f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f411a311af7b398ee046966df01d80220166c9c2fb3a8aa771ef8649c47b4ebb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8e698e80a3c0b7a6a95388554ea1d7cf01fe14c4cc5e616f4baaa9c8d3dd89c1"
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
