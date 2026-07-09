class ProtocGenDoc < Formula
  desc "Documentation generator plugin for Google Protocol Buffers"
  homepage "https://github.com/pseudomuto/protoc-gen-doc"
  url "https://github.com/pseudomuto/protoc-gen-doc/archive/refs/tags/v1.5.1.tar.gz"
  sha256 "75667f5e4f9b4fecf5c38f85a046180745fc73f518d85422d9c71cb845cd3d43"
  license "MIT"
  revision 1
  head "https://github.com/pseudomuto/protoc-gen-doc.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1a25a72f55c678f4b410f42071ad746acae3648efd5a75f2a00a297d3fe4100f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1a25a72f55c678f4b410f42071ad746acae3648efd5a75f2a00a297d3fe4100f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1a25a72f55c678f4b410f42071ad746acae3648efd5a75f2a00a297d3fe4100f"
    sha256 cellar: :any_skip_relocation, sonoma:        "cfe51844f9ac4474fff2dc94b75350df856e2253f97dd4b463d195d6d849ac84"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c249c91041de867871ec10f534418d65fd5904785762ed9da92f636817d20c47"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b27ef3c389ef7756cc9a8399f8f49c527b03b3abe972e58e38f719787fe789e6"
  end

  depends_on "go" => :build
  depends_on "protobuf"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/protoc-gen-doc"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/protoc-gen-doc -version")

    protofile = testpath/"proto3.proto"
    protofile.write <<~EOS
      syntax = "proto3";
      package proto3;

      message Request {
        string name = 1;
        repeated int64 key = 2;
      }
    EOS

    system "protoc", "--doc_out=.", "--doc_opt=html,index.html", "proto3.proto"
    assert_path_exists testpath/"index.html"
    refute_predicate (testpath/"index.html").size, :zero?
  end
end
