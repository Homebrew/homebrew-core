class ProtocGenGo < Formula
  desc "Go support for Google's protocol buffers"
  homepage "https://github.com/golang/protobuf"
  url "https://github.com/golang/protobuf/archive/v1.4.3.tar.gz"
  sha256 "5736f943f8647362f5559689df6154f3c85d261fb088867c8a68494e2a767610"
  license "BSD-3-Clause"
  revision 2
  head "https://github.com/golang/protobuf.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "54a34bcaab0de763667a50394360eb0e5f756c5d85aa3a347baa9220c7dbe506"
    sha256 cellar: :any_skip_relocation, big_sur:       "c8c232252dcfc31270f02c02958b75c43efb98cebaa4ff16ca08862f481a215b"
    sha256 cellar: :any_skip_relocation, catalina:      "4b93ec65d522bdd8940f6cbd07098f6b3711171b1c0023284b073a8cb5e350a5"
    sha256 cellar: :any_skip_relocation, mojave:        "e81ceeb5e1c4496267548a4c1257250e6117a7c6b267ae6a557993df4f48c5b9"
  end

  depends_on "go" => :build
  depends_on "protobuf"

  def install
    system "go", "build", *std_go_args, "-ldflags", "-s -w", "./protoc-gen-go"
    prefix.install_metafiles
  end

  test do
    protofile = testpath/"proto3.proto"
    protofile.write <<~EOS
      syntax = "proto3";
      package proto3;
      message Request {
        string name = 1;
        repeated int64 key = 2;
      }
    EOS
    system "protoc", "--go_out=.", "proto3.proto"
    assert_predicate testpath/"proto3.pb.go", :exist?
    refute_predicate (testpath/"proto3.pb.go").size, :zero?
  end
end
