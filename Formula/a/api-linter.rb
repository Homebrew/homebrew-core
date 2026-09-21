class ApiLinter < Formula
  desc "Linter for APIs defined in protocol buffers"
  homepage "https://linter.aip.dev/"
  url "https://github.com/googleapis/api-linter/archive/refs/tags/v2.4.0.tar.gz"
  sha256 "8625ac84518ae0db94bd112858d30f4a91fcbb63b8743f64a962faa3ab3d406a"
  license "Apache-2.0"
  head "https://github.com/googleapis/api-linter.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "211f60fc6210e2ee1b6e59ca9b746ed57f4ae8f717394fb7a13dbc721170df6b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "211f60fc6210e2ee1b6e59ca9b746ed57f4ae8f717394fb7a13dbc721170df6b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "211f60fc6210e2ee1b6e59ca9b746ed57f4ae8f717394fb7a13dbc721170df6b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "211f60fc6210e2ee1b6e59ca9b746ed57f4ae8f717394fb7a13dbc721170df6b"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "b9c6659555888344d91d150fff8dc802ecda8baeeb785a76c6f68155662f0b07"
    sha256 cellar: :any,                 x86_64_linux:      "30e89621edb79bb4e7bebdd97473caeaaa79eccaaecc59d7b62a53f83045953d"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args, "./cmd/api-linter"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/api-linter --version")

    protofile = testpath/"proto3.proto"
    protofile.write <<~EOS
      syntax = "proto3";
      package proto3;

      message Request {
        string name = 1;
        repeated int64 key = 2;
      }
    EOS

    assert_match "message: Missing comment over \"Request\"", shell_output("#{bin}/api-linter proto3.proto 2>&1")
  end
end
