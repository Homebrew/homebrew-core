class ApiLinter < Formula
  desc "Linter for APIs defined in protocol buffers"
  homepage "https://linter.aip.dev/"
  url "https://github.com/googleapis/api-linter/archive/refs/tags/v2.4.0.tar.gz"
  sha256 "8625ac84518ae0db94bd112858d30f4a91fcbb63b8743f64a962faa3ab3d406a"
  license "Apache-2.0"
  head "https://github.com/googleapis/api-linter.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "475a87acccbe7113b2c76ea2c542d5cf99b85ed30a5a60af1f17f39e10490ae3"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "475a87acccbe7113b2c76ea2c542d5cf99b85ed30a5a60af1f17f39e10490ae3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "475a87acccbe7113b2c76ea2c542d5cf99b85ed30a5a60af1f17f39e10490ae3"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "9342f37055ea5bbe8709324ff53f8949816fabb137cfeb7a56d4e099527e8ad5"
    sha256 cellar: :any,                 x86_64_linux:      "cbba0d007e087856f7c4482c18782b73a567f9b5fd9b3f04f851e4178d8c7904"
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
