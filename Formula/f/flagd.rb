class Flagd < Formula
  desc "Feature flag daemon with a Unix philosophy"
  homepage "https://github.com/open-feature/flagd"
  url "https://github.com/open-feature/flagd.git",
      tag:      "flagd/v0.15.5",
      revision: "971463d4fea1e8e2614cd7372c237341f1c00c00"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1858f6ef99eee07b36d2779c381a05901ec1e4e13c0b45a17856771a2beb24c7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ad70b75af75626f2176167dba88c62c04afaf646c837595c52574c6689d69a98"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5531357c18f47a812943f32f7b07b28c408915a0b584858633109ec96de1f14c"
    sha256 cellar: :any_skip_relocation, sonoma:        "9eb59b35616bf0e05287c5cd75098aa35c907168b87dd955bd42af0589b2f1a6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f5f1727d4509bfa59e79bad12a35f856d03a86f23bc24a7ea73736ee8d882d0d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "20530671c1b7c9cd0998de9358286fa81ef338d357560e02ae3b2d9bc9bae606"
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
