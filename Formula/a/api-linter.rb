class ApiLinter < Formula
  desc "Linter for APIs defined in protocol buffers"
  homepage "https://linter.aip.dev/"
  url "https://github.com/googleapis/api-linter/archive/refs/tags/v2.4.1.tar.gz"
  sha256 "253dc16eac247991b2c27d37e044bba2f1c4040da4a20fc3e82af4e800149b91"
  license "Apache-2.0"
  head "https://github.com/googleapis/api-linter.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "3bf773f270fde947e63ece734b57f2c3c99242811fd0178d2a5a71a4dcc6eeee"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "3bf773f270fde947e63ece734b57f2c3c99242811fd0178d2a5a71a4dcc6eeee"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "3bf773f270fde947e63ece734b57f2c3c99242811fd0178d2a5a71a4dcc6eeee"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "d813043005ee132d46d0209099b88636d7910a639279a20153996f5f34f7d008"
    sha256 cellar: :any,                 x86_64_linux:      "6293affdf27f684f2d3dded3bfb4fea7054ec73e802443e74b67309b001a0b62"
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
