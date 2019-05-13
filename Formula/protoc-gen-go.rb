class ProtocGenGo < Formula
  desc "Go support for Google's protocol buffers"
  homepage "https://github.com/golang/protobuf"
  url "https://github.com/golang/protobuf/archive/v1.3.1.tar.gz"
  sha256 "3f3a6123054a9847093c119895f1660612f301fe95358f3a6a1a33fd0933e6cf"
  head "https://github.com/golang/protobuf.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "939188ff166b71c1f42f72bfe7b5abdb8a84a93cf0abd88a030a0abcd4bae238" => :mojave
    sha256 "8c5a1f2ecfa91c7c646353315f61ef35a81cc7087b68793a8a1ebd61a7e4ff0c" => :high_sierra
    sha256 "ce0c1783bbb5f79e6a8dbc14f160b5e7b9c6e06ff7a682343c72184c46885f09" => :sierra
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
