class ApiLinter < Formula
  desc "Linter for APIs defined in protocol buffers"
  homepage "https://linter.aip.dev/"
  url "https://github.com/googleapis/api-linter/archive/refs/tags/v2.0.0.tar.gz"
  sha256 "e42c23eb6ee3b040555453b8bb92a624f8a388821db53ff5691c8a188deb37a7"
  license "Apache-2.0"
  head "https://github.com/googleapis/api-linter.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6a7a163028bf85f562da0a15a1885f5ed092039bcc2238d8b94d8f00d5d8370a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6a7a163028bf85f562da0a15a1885f5ed092039bcc2238d8b94d8f00d5d8370a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6a7a163028bf85f562da0a15a1885f5ed092039bcc2238d8b94d8f00d5d8370a"
    sha256 cellar: :any_skip_relocation, sonoma:        "2f301a9883efdce8e8bd950fdbf0842919defef460b13ce36a96a0c39e630d06"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "05fb0f72cab0c1eb5b0dbe9029e5eb378db7d652bf1d9619c77a5f6cea8290c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f748f4f8d76703b2491bb1c39981e68f68ae0ef3702b870a4145263981cc045e"
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
