class ProtocGenGo < Formula
  desc "Go support for Google's protocol buffers"
  homepage "https://github.com/protocolbuffers/protobuf-go"
  url "https://github.com/protocolbuffers/protobuf-go/archive/refs/tags/v1.36.9.tar.gz"
  sha256 "4d82e5c1f83f4dc3145452055c549bec8d795e24d66aebc6bf0af2bc2839b46b"
  license "BSD-3-Clause"
  head "https://github.com/protocolbuffers/protobuf-go.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cf88f7d3e3d96fa5744c021c050fe7975789fa6880aa170c5d550dcbe7bf8945"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cf88f7d3e3d96fa5744c021c050fe7975789fa6880aa170c5d550dcbe7bf8945"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cf88f7d3e3d96fa5744c021c050fe7975789fa6880aa170c5d550dcbe7bf8945"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cf88f7d3e3d96fa5744c021c050fe7975789fa6880aa170c5d550dcbe7bf8945"
    sha256 cellar: :any_skip_relocation, sonoma:        "ff23a83f1b1f27979211eb02d848c2ad32ba2cdabd0e6fa8fae60674c585e37b"
    sha256 cellar: :any_skip_relocation, ventura:       "ff23a83f1b1f27979211eb02d848c2ad32ba2cdabd0e6fa8fae60674c585e37b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "66d2000e9f59782fae5f99e470b20608b7ee1170318412da4e64696ed2fdfdc9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "87e970d043d1c5a3852a36268fe4b95ad5e4284cb8ef939948b6ab9e0357cd2d"
  end

  depends_on "go" => :build
  depends_on "protobuf"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/protoc-gen-go"
  end

  test do
    protofile = testpath/"proto3.proto"
    protofile.write <<~EOS
      syntax = "proto3";
      package proto3;
      option go_package = "package/test";
      message Request {
        string name = 1;
        repeated int64 key = 2;
      }
    EOS
    system "protoc", "--go_out=.", "--go_opt=paths=source_relative", "proto3.proto"
    assert_path_exists testpath/"proto3.pb.go"
    refute_predicate (testpath/"proto3.pb.go").size, :zero?
  end
end
