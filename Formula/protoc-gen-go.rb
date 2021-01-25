class ProtocGenGo < Formula
  desc "Go support for Google's protocol buffers"
  homepage "https://github.com/golang/protobuf"
  url "https://github.com/golang/protobuf/archive/v1.4.3.tar.gz"
  sha256 "5736f943f8647362f5559689df6154f3c85d261fb088867c8a68494e2a767610"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/golang/protobuf.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "72b0d9ecea80b943041b675e7b4b7cd30eb7c8b8c7e259ea9f10d8ea80a300d7" => :big_sur
    sha256 "8f72ac9dd4ac5745cd1a6bc97e4c777a1da32729247a5009bdb2b7d7c822f119" => :arm64_big_sur
    sha256 "342612ad4c08732410ae7d159d5743a2c66f3a6a1ea410a8fed64fcad195118e" => :catalina
    sha256 "cb8c75a45f9035bee99008a9101207ba0e74e41a28ef3ebdb4e1e492c769bd3d" => :mojave
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
