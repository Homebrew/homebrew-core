class ApiLinter < Formula
  desc "Linter for APIs defined in protocol buffers"
  homepage "https://linter.aip.dev/"
  url "https://github.com/googleapis/api-linter/archive/refs/tags/v2.1.0.tar.gz"
  sha256 "820753a8f624e53777028c87a76566f25b6343e5ea5913ecd64d6357b807248d"
  license "Apache-2.0"
  head "https://github.com/googleapis/api-linter.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "36b6b6d8f3e6e9f92da96c80b324c7c6b0639c5db5832090ea9271abf0fc85db"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "36b6b6d8f3e6e9f92da96c80b324c7c6b0639c5db5832090ea9271abf0fc85db"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "36b6b6d8f3e6e9f92da96c80b324c7c6b0639c5db5832090ea9271abf0fc85db"
    sha256 cellar: :any_skip_relocation, sonoma:        "5b05d0d1870fd26d15ad7ae6552a3febce29cf66e1ce842ee568bbcef712fc36"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3af48c074b9bc6074f99d0069a7830209d45ecabb023cc3afe1298d56e0a3e22"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5566560cc4162b72b9ce0b34e58a4b2d34a2e83115ee26a03b609c0e1cb2c794"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/api-linter"
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
