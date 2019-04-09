class ProtocGenGo < Formula
  desc "Go support for Google's protocol buffers"
  homepage "https://github.com/golang/protobuf"
  url "https://github.com/golang/protobuf/archive/v1.3.0.tar.gz"
  sha256 "f44cfe140cdaf0031dac7d7376eee4d5b07084cce400d7ecfac4c46d33f18a52"

  bottle do
    cellar :any_skip_relocation
    sha256 "8aebaaa56b0888abf30266a29a6544bbb2c2721e3cb7981ac25a37a69833c3ad" => :mojave
    sha256 "aef9fa9eee83d2d66ced9f4a715bfb13d27fa974a9146344bedf91ba1aed8488" => :high_sierra
    sha256 "d793e008f393f2af647186b07ce4e3cc1a4a0da0bde717b57c46189fedfa14d0" => :sierra
  end

  depends_on "go" => :build
  depends_on "protobuf"

  def install
    ENV["GOPATH"] = buildpath
    ENV["GO111MODULE"] = "off"
    (buildpath/"src/github.com/golang").mkpath
    ln_s buildpath, buildpath/"src/github.com/golang/protobuf"
    system "go", "build", "-o", bin/"protoc-gen-go", "protoc-gen-go/main.go"
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
