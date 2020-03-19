class ProtocGenGo < Formula
  desc "Go support for Google's protocol buffers"
  homepage "https://github.com/golang/protobuf"
  url "https://github.com/golang/protobuf/archive/v1.3.5.tar.gz"
  sha256 "a3ab705fc75b48cba9ac18d10cb4012416714cc8edaeb151a85c46ac3a65033b"
  head "https://github.com/golang/protobuf.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "f294fc2731f7068038f435d20a995efb55b5887a1330623f9eca092b46f152c6" => :catalina
    sha256 "a7c861710913754302eaccd62b3fc1b506f31a2d3a1bd98dc809e5ca7adcc4b5" => :mojave
    sha256 "bb8d5634d39418a315e8410b734b77b59706a4e96cfb267bf187193f73dbad23" => :high_sierra
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
