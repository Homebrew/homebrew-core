class ApiLinter < Formula
  desc "Linter for APIs defined in protocol buffers"
  homepage "https://linter.aip.dev/"
  url "https://github.com/googleapis/api-linter/archive/refs/tags/v2.3.0.tar.gz"
  sha256 "a6713f5d14be322eca0ae211412039cc69d558270766cdbf1b8e5e950c6a3625"
  license "Apache-2.0"
  head "https://github.com/googleapis/api-linter.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c537dac8b8934b8e18ee894e3b0633abadf0154bb86f15da5735d31ff58bd989"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c537dac8b8934b8e18ee894e3b0633abadf0154bb86f15da5735d31ff58bd989"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c537dac8b8934b8e18ee894e3b0633abadf0154bb86f15da5735d31ff58bd989"
    sha256 cellar: :any_skip_relocation, sonoma:        "ef6034e71dee39a9983ff9b1443fea899bd8aff71285218394ffa146afa9703e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0339ad8ccee909b8e9809a38e46687bf2cb57ef1f14390e3d2df29adfca776ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4d11740f5b77952fe67eedfd319735f75d7dab3b5c454b03a568944415f358a8"
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
