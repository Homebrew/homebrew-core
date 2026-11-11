class Clippy < Formula
  desc "Copy files from your terminal that actually paste into GUI apps"
  homepage "https://github.com/neilberkman/clippy"
  url "https://github.com/neilberkman/clippy/archive/refs/tags/v1.10.0.tar.gz"
  sha256 "07870271de5a1c263317bde3f47fa2cad068111700b32379f436757ef8d936c5"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "3f8b693ee267f5ef722635b8a3c601c39ac6aa35337a3bf4798a50dbfe3ef0a9"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "fa9cfa9be33e988a8d87ae5aa6d344163bfc76609e9340220b89c71babfdea5e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "cf2c05c7aeb15feef62cd78f00a2471c38ee8f88a5999a11201b290cdb307e26"
  end

  depends_on "go" => :build
  depends_on :macos

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
      -X github.com/neilberkman/clippy/cmd/internal/common.Version=#{version}
      -X github.com/neilberkman/clippy/cmd/internal/common.Commit=#{tap.user}
      -X github.com/neilberkman/clippy/cmd/internal/common.Date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/clippy"
    system "go", "build", *std_go_args(ldflags:, output: bin/"pasty"), "./cmd/pasty"

    %w[clippy pasty].each do |cmd|
      generate_completions_from_executable(bin/cmd, shell_parameter_format: :cobra)
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/clippy --version")
    assert_match version.to_s, shell_output("#{bin}/pasty --version")

    # Writing to the pasteboard needs a GUI session, so exercise the MCP server's file buffer instead
    (testpath/"test.txt").write("test content\n")
    json = <<~JSON
      {"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-03-26"}}
      {"jsonrpc":"2.0","id":2,"method":"tools/call","params":{"name":"buffer_copy","arguments":{"file":"#{testpath}/test.txt"}}}
    JSON
    assert_match "Copied 2 lines from test.txt", pipe_output("#{bin}/clippy mcp-server 2>&1", json, 0)
  end
end
