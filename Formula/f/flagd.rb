class Flagd < Formula
  desc "Feature flag daemon with a Unix philosophy"
  homepage "https://github.com/open-feature/flagd"
  url "https://github.com/open-feature/flagd.git",
      tag:      "flagd/v0.15.4",
      revision: "6f71a7a558337e1ccf3ca94193b52ad468326968"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4297ac2c246aa0fb2e1ae6942424f7d2d5d44fbe4bb21ff5f39378ce3768b116"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c048b28c2ff4fff1e164458dd5b2843cd0d23d3b6776623a1091f798b6c0bb79"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "054722698cc8fcc0aba6a9a4c1da7801b19bd4495a9f1ca053746fbc1ff1d037"
    sha256 cellar: :any_skip_relocation, sonoma:        "11d4131b4efc1e311fd6786d9f6a469fe44288ea76b13b484349dd205af3abe0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f040ed2b50dae251b0f405b8051fa982cf25cfd9501d7c0eeafee595e9f4f8c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7d0cf3156a2df797f67cdb33f148a36fd779593be13378caa6f606841dd60cfc"
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
