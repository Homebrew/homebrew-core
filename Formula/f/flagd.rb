class Flagd < Formula
  desc "Feature flag daemon with a Unix philosophy"
  homepage "https://github.com/open-feature/flagd"
  url "https://github.com/open-feature/flagd.git",
      tag:      "flagd/v0.12.0",
      revision: "a444b74685b7bcf1d77370374729633f3d9a1d9f"
  license "Apache-2.0"
  head "https://github.com/open-feature/flagd.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "73249d24d5e23dc79af8aa5a73b15afdeb956d0fa0eaaf4f1d4cc09f4ec39dda"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "73249d24d5e23dc79af8aa5a73b15afdeb956d0fa0eaaf4f1d4cc09f4ec39dda"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "73249d24d5e23dc79af8aa5a73b15afdeb956d0fa0eaaf4f1d4cc09f4ec39dda"
    sha256 cellar: :any_skip_relocation, sonoma:        "d0c52025f247667d7226c59d6a5a18dfaaf2bc44f21c4647643d5b4d8204ec56"
    sha256 cellar: :any_skip_relocation, ventura:       "d0c52025f247667d7226c59d6a5a18dfaaf2bc44f21c4647643d5b4d8204ec56"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "13a8bfe479748c3638022b08ae5bd4cd23071370759cbd2fb6dccfb91cc324df"
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
