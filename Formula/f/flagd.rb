class Flagd < Formula
  desc "Feature flag daemon with a Unix philosophy"
  homepage "https://github.com/open-feature/flagd"
  url "https://github.com/open-feature/flagd.git",
      tag:      "flagd/v0.12.3",
      revision: "3f4690e55013680abe36a84156d52dffb190efd5"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dadb1601b41a5e537d6990d75c1189dd94e5a6eda9da929751e0f5bed4368656"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bc539c41ff9a15f0aef1d688e1f7b164cfe7f356f8f123b78af4961d9b51c9a8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0ef17631fc833000515e34c22d7a65a5077d6251a2d500255547c32d316de59a"
    sha256 cellar: :any_skip_relocation, sonoma:        "de447ee90cebd5ba4b2c1c63256f70bc4891cfe5f882303ce82c8cc3c7297322"
    sha256 cellar: :any_skip_relocation, ventura:       "d6c307245267dc5d558dff6612fff1aa906352ed9621ed64bd91dfd039c7316e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c3e2741763f115b442fa855eebd6c2da0b2a542fed9d671a06e5227376d0706b"
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
