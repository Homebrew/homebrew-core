class Flagd < Formula
  desc "Feature flag daemon with a Unix philosophy"
  homepage "https://flagd.dev"
  url "https://github.com/open-feature/flagd.git",
      tag:      "flagd/v0.16.0",
      revision: "80b9e9548163c1adbd28d45ca52364956e7fa08f"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e8581d2077862dc033418e8732352b776a94e8f61e067d2129494e3a8ae7244f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "be8818904d771753ac4f7a13aa48512b97dfbec25ccdf6b5c36d98f8ae108dfa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "56b40a77d38f430655eff223f542b974963973f21dc1228615036e54c0a143c2"
    sha256 cellar: :any_skip_relocation, sonoma:        "a350e3bfef2e64733709bc7e9f09eec79d24135c98e0efbb29bfa3db9a0cdc46"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "82bc009fcdbe2f76fe1b8727c490cc2b550559aca1c6884cd097cd024329c1e7"
    sha256 cellar: :any,                 x86_64_linux:  "44efbc94f7d377582551d237f7c73858f77e714c13c7e386811085bb993d2855"
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
      sleep 5 if OS.mac? && Hardware::CPU.intel?
      assert_match(/true/, shell_output(resolve_boolean_command))
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
