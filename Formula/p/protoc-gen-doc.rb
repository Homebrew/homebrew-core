class ProtocGenDoc < Formula
  desc "Documentation generator plugin for Google Protocol Buffers"
  homepage "https://github.com/pseudomuto/protoc-gen-doc"
  url "https://github.com/pseudomuto/protoc-gen-doc/archive/refs/tags/v1.5.1.tar.gz"
  sha256 "75667f5e4f9b4fecf5c38f85a046180745fc73f518d85422d9c71cb845cd3d43"
  license "MIT"
  head "https://github.com/pseudomuto/protoc-gen-doc.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4cc365e45a28d202cf246071d99bcec458033ae269cd4b69d16691628c783e83"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8f0234e290bc9f5d0d09bf239cc5c413588bc49e01d101ca7dc5ea26e4dfd2fa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8f0234e290bc9f5d0d09bf239cc5c413588bc49e01d101ca7dc5ea26e4dfd2fa"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8f0234e290bc9f5d0d09bf239cc5c413588bc49e01d101ca7dc5ea26e4dfd2fa"
    sha256 cellar: :any_skip_relocation, sonoma:        "18a8a8ac59d204179f88c0371314c66da653062752267295cc89ccbab9da0d60"
    sha256 cellar: :any_skip_relocation, ventura:       "18a8a8ac59d204179f88c0371314c66da653062752267295cc89ccbab9da0d60"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "eec4e5b96583ea14c8a9e43f0f494abdae35944eeecc1878d31d3150242a96b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e23d75e3d15957c6ba2581fe5e3688c5fc7a6b78572bb80df3ad360730b07585"
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
