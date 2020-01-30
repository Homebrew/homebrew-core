class ProtocGenGo < Formula
  desc "Go support for Google's protocol buffers"
  homepage "https://github.com/golang/protobuf"
  url "https://github.com/golang/protobuf/archive/v1.3.3.tar.gz"
  sha256 "b3a1440808d6ed4dc0d194c482de029f6c116b1de7f7a3bf927324d965ff3853"
  head "https://github.com/golang/protobuf.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "777f058de704ae1cc116c537ac00b868401818ecfcbf505993fcfc325853dd40" => :catalina
    sha256 "203a532a500411acd36873816c788b439fbd2077b4253eb1975a6da7045ec08c" => :mojave
    sha256 "48f9810dde13eda31b003eda0b2c409572fde48ef33ffd0fcb9e8979416d4c69" => :high_sierra
    sha256 "c66cc2bd02f7dd004d3880b495b598d578382caf583fea04029c39e0773e0f0b" => :sierra
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
