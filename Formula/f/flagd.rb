class Flagd < Formula
  desc "Feature flag daemon with a Unix philosophy"
  homepage "https://github.com/open-feature/flagd"
  url "https://github.com/open-feature/flagd.git",
      tag:      "flagd/v0.15.2",
      revision: "4b947f7fb8997ad7891e633624d1ab16fbfaa984"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d7beba50f67922aa980691b5d32d53039d760bb558e2d8c049373c67d479ed82"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9ec489ffb80a4a6fb1fd01af9247f5b1615cf9cb7ca6cfe6901a35f5536dc77c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "356e4ba7a3df1e71d7757df20a67cfeb349881beb418c6153494053046ca16b2"
    sha256 cellar: :any_skip_relocation, sonoma:        "3d6e93e702c1b674bdb7c8ba388fec2c236a9a7e221cac26bd8197b100120087"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6b8677bd98b7170d6b3a3cbe6ee7fe92ae42213f66b22fd2f6440cf73d492dfc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ad382dd30eea9a9d0de691f02f298d8cd4fa6e43e94adc2775754566ae568a2f"
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
