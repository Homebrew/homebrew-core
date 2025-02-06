class Flagd < Formula
  desc "Feature flag daemon with a Unix philosophy"
  homepage "https://github.com/open-feature/flagd"
  url "https://github.com/open-feature/flagd.git",
      tag:      "flagd/v0.12.1",
      revision: "82dc4e4c6c229e42ecb723f4866ba343be9d2b89"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "80aa357e3ab13a7e0d6c4c4ddfef8103a96c1cc3601221ab09986035b061e5e2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "80aa357e3ab13a7e0d6c4c4ddfef8103a96c1cc3601221ab09986035b061e5e2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "80aa357e3ab13a7e0d6c4c4ddfef8103a96c1cc3601221ab09986035b061e5e2"
    sha256 cellar: :any_skip_relocation, sonoma:        "fd2517daf3095929b764345dcdfe86bea65278fdf97af6bd0333483ab3128468"
    sha256 cellar: :any_skip_relocation, ventura:       "fd2517daf3095929b764345dcdfe86bea65278fdf97af6bd0333483ab3128468"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "88486affd411cb9bd0d1d4d1c2b32484e2c4896824c1845cea417703b90245a6"
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
