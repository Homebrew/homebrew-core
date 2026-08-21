class Flagd < Formula
  desc "Feature flag daemon with a Unix philosophy"
  homepage "https://flagd.dev"
  url "https://github.com/open-feature/flagd.git",
      tag:      "flagd/v0.16.2",
      revision: "e04523785a745c48c552101901b0ea858efbd73a"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "856230f14af44e476511429ebaf331a8c4dd43901d5dab0bf38ac296783699e2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7299cdd24d90b66babd45605c3082bf326ba7227ddf52ce19e5baf9d70a257fe"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "42018413a820819a660f7025aa96a92b49cb7965479db9ce05d7dc44ee975d82"
    sha256 cellar: :any_skip_relocation, sonoma:        "abb24e17d9c8297c205903b5b1edf094e2b343c63de9654aaaecbae82fdaa409"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8d9998f7a0baf6d76d65ab3f6742cdc8e8e31dfe16a7eed3897c9c9b591b1c23"
    sha256 cellar: :any,                 x86_64_linux:  "12969b358598cd622a4640ae7602e7edbd851a9908299304e95bd5e73d7ccd72"
  end

  depends_on "go" => :build

  def install
    ENV["GOPRIVATE"] = "buf.build/gen/go"
    ldflags = %W[
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
