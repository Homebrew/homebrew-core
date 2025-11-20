class Flagd < Formula
  desc "Feature flag daemon with a Unix philosophy"
  homepage "https://github.com/open-feature/flagd"
  url "https://github.com/open-feature/flagd.git",
      tag:      "flagd/v0.12.9",
      revision: "1ee636aa039ad862f055831bd2ab42216fe30865"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b5c17ef41e3729296edf75c50db51717e77e5546523707befa40753ca057fc22"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "86b5457cbffac14b621c2f7c3b10d924cbb3f257b066528ae73b16ac13308e3f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cd540364119080d40fbd5f151f508f4aaf957eb8aa7795d48d1cc5421de7ce88"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1c1be9a397de335ee8a293474c20fa344001190b3a7e1adc762ae685ef0e5268"
    sha256 cellar: :any_skip_relocation, sonoma:        "7da35ae4bd545fa9b9ae0f547d6b8fc377a034cc973e638139c8ba696536cc41"
    sha256 cellar: :any_skip_relocation, ventura:       "0dec4c7fcf3fe7be3bb23167b153887b2e2dc7afb52a2bfca529e839923c890c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "02a3f67aa69c850e9ff180db4170a5250894c1b7db22a9a9baaece04cfe08990"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "61f8c0876041ddd70834ea658876fa57becf3a5393253f76291e6259bc6a8c9f"
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
