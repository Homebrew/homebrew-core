class ProtocGenGo < Formula
  desc "Go support for Google's protocol buffers"
  homepage "https://github.com/golang/protobuf"
  url "https://github.com/golang/protobuf/archive/v1.4.3.tar.gz"
  sha256 "5736f943f8647362f5559689df6154f3c85d261fb088867c8a68494e2a767610"
  license "BSD-3-Clause"
  head "https://github.com/golang/protobuf.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "3262f7f32414049e611b4becb6d7469d438ee687cef71c417dd4433250acdace" => :catalina
    sha256 "627661b585cd509d4bd6dbfb31f90f6d166cd85565301c379c4507a5bb868ab1" => :mojave
    sha256 "c4c574024cdfa6f27e8df9d4683a6607ea77ceb5b11eafa8b8d60e6493ca80b9" => :high_sierra
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
