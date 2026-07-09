class ApiLinter < Formula
  desc "Linter for APIs defined in protocol buffers"
  homepage "https://linter.aip.dev/"
  url "https://github.com/googleapis/api-linter/archive/refs/tags/v2.3.1.tar.gz"
  sha256 "cf07583fea93604b91a9f08a32bb6ee471d2db5177e20d1bf2ca99e8ad8dde1d"
  license "Apache-2.0"
  head "https://github.com/googleapis/api-linter.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "328756fe4d2ff20c13a96dad25f9356dbe61aacc55fbeec48f093019d1937c07"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "328756fe4d2ff20c13a96dad25f9356dbe61aacc55fbeec48f093019d1937c07"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "328756fe4d2ff20c13a96dad25f9356dbe61aacc55fbeec48f093019d1937c07"
    sha256 cellar: :any_skip_relocation, sonoma:        "c42e49f0368dbaa76b0e702555d7e1d78047ceda97e79f4783d218e9a7c37b18"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a339d47c51dd685c3775ffdb657b58a7b801ba3dfd22f48a8f54f3e307193183"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "188b2c1c7081f2b5e6922719847612829f694fca8901c792a6b2edafe5e48689"
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
