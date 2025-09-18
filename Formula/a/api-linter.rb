class ApiLinter < Formula
  desc "Linter for APIs defined in protocol buffers"
  homepage "https://linter.aip.dev/"
  url "https://github.com/googleapis/api-linter/archive/refs/tags/v1.71.0.tar.gz"
  sha256 "6010f354cc56f17a9f7750718baef40edb65255f879a821738c0d925acdba804"
  license "Apache-2.0"
  head "https://github.com/googleapis/api-linter.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9a487c080b0fd9e904c4a111b1b947c25544d2dc0530e53d9c2b6ff5ade3e4b9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "12bd1b466c3175983210bd818455918ac11502b0abadca934d66be631b66b48e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "12bd1b466c3175983210bd818455918ac11502b0abadca934d66be631b66b48e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "12bd1b466c3175983210bd818455918ac11502b0abadca934d66be631b66b48e"
    sha256 cellar: :any_skip_relocation, sonoma:        "e527afef6842be4adb9872ea73752cfeffb8a305d87d57891928ea145ac7e7cf"
    sha256 cellar: :any_skip_relocation, ventura:       "e527afef6842be4adb9872ea73752cfeffb8a305d87d57891928ea145ac7e7cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b981041250fb8851c3befaab8b0eb08bfc24407ef7a3685ca812f296e06ee914"
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
