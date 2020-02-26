class ProtocGenGo < Formula
  desc "Go support for Google's protocol buffers"
  homepage "https://github.com/golang/protobuf"
  url "https://github.com/golang/protobuf/archive/v1.3.4.tar.gz"
  sha256 "5e4279eb197ff7271cb06ae97a16f721d0fd6962ff2d2560831309c0900e72c4"
  head "https://github.com/golang/protobuf.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "b2eb49e35e2e347cb61216269fa6a8308ed33ab02f00b6f161903eda39eb3a28" => :catalina
    sha256 "c013bfd815378763f3c99eb2025a72e1d2cf2ca35ba0045c475b678f4e1ea4f2" => :mojave
    sha256 "8e3788a3da762b667b7706f38d9da66e1373480003433c1f54f44f54375d9dd6" => :high_sierra
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
