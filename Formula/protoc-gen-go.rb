class ProtocGenGo < Formula
  desc "Go support for Google's protocol buffers"
  homepage "https://github.com/golang/protobuf"
  url "https://github.com/golang/protobuf/archive/v1.2.0.tar.gz"
  sha256 "157a148ae4e132eb169ec794b6cb43f1002780eeacaea8b0694811d1948fb1ec"

  depends_on "go" => :build
  depends_on "protobuf"

  def install
    ENV["GOPATH"] = buildpath
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
