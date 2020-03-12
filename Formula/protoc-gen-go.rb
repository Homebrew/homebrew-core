class ProtocGenGo < Formula
  desc "Go support for Google's protocol buffers"
  homepage "https://github.com/golang/protobuf"
  url "https://github.com/golang/protobuf/archive/v1.3.5.tar.gz"
  sha256 "a3ab705fc75b48cba9ac18d10cb4012416714cc8edaeb151a85c46ac3a65033b"
  head "https://github.com/golang/protobuf.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "8f2e5bc9d1429f9dea8569f977443b46238889c3789d58f4f0b1f2c58009d7e9" => :catalina
    sha256 "3b21debd17648c30a87e79afd66f3e6797e6937134e9ce2eed32a8d0df53df8b" => :mojave
    sha256 "92e19f57d5ecefd0b45c1c4418920a1413edeb0113d92a07ea48fb3d8c84a302" => :high_sierra
  end

  depends_on "go" => :build
  depends_on "protobuf"

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/golang/protobuf").install buildpath.children
    system "go", "install", "github.com/golang/protobuf/protoc-gen-go"
    bin.install buildpath/"bin/protoc-gen-go"
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
