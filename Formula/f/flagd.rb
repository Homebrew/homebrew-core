class Flagd < Formula
  desc "Feature flag daemon with a Unix philosophy"
  homepage "https://flagd.dev"
  url "https://github.com/open-feature/flagd.git",
      tag:      "flagd/v0.18.2",
      revision: "71490eb4de5cc590de53ffbda99813ff41b8366c"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c53e017e8579602107d730fd948bb1e94e90d3915b5c348bc8344b3c58193e43"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "8c19af2bfa8da2a5b6cf84fae09b1b47920d7bd4926e96d8d82ce9e625f9dfbe"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "bc583609063b3999e855a36cbf123cb5bc49336b0877be56ae881fbc231f1d9f"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "ec63dfb59c488ab87d66f35f5b0295af1e63f33fe89c9eaf504e35d0011ce396"
    sha256 cellar: :any,                 x86_64_linux:      "0f1c47634c9224f6fc3e77b22e14ffbc632013d6a8332a37e2eab3e94f6294af"
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
