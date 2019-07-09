class ProtocGenGo < Formula
  desc "Go support for Google's protocol buffers"
  homepage "https://github.com/golang/protobuf"
  url "https://github.com/golang/protobuf/archive/v1.3.2.tar.gz"
  sha256 "c9cda622857a17cf0877c5ba76688a931883e505f40744c9495638b6e3da1f65"
  head "https://github.com/golang/protobuf.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "80c035e22ba7de3927be1ee7dd10427827799d5fe06d001da19b760413c9f292" => :mojave
    sha256 "010f1f168b06ca15d68d349ffcbb4e2ac956145e751fe88b678baf7d0a773786" => :high_sierra
    sha256 "135dca0f702150d991b367c495a7c55ad05636490c74e6928cb336ae100bb252" => :sierra
  end

  depends_on "go" => :build
  depends_on "protobuf"

  def install
    ENV["GOPATH"] = buildpath
    ENV["GO111MODULE"] = "off"
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
