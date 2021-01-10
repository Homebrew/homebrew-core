class ProtocGenGogo < Formula
  desc "Protocol Buffers for Go with Gadgets"
  homepage "https://github.com/gogo/protobuf"
  url "https://github.com/gogo/protobuf/archive/v1.3.2.tar.gz"
  sha256 "2bb4b13d6e56b3911f09b8e9ddd15708477fbff8823c057cc79dd99c9a452b34"
  license "BSD-3-Clause"
  head "https://github.com/gogo/protobuf.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "7d66d0581956943a2d3ee73f881a0d455466c4f0c94d080685afb5ca2b6951b6" => :big_sur
    sha256 "89ca97d74201bb2acbf16d80f657d0ffbad1c71425724ee2865b8423fa3e927e" => :arm64_big_sur
    sha256 "11c3555306af5dcfbaf85953c96fb386c4b864da16d91f45d99435fd55ee3615" => :catalina
    sha256 "5767e5448ae3e8a70d961cca120aa12c8491db0d498bafe1abb3d935c208bf8f" => :mojave
  end

  depends_on "go" => :build
  depends_on "protobuf"

  def install
    system "go", "build", *std_go_args, "-ldflags", "-s -w", "./protoc-gen-gogo"
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
    system "protoc", "--gogo_out=.", "proto3.proto"
    assert_predicate testpath/"proto3.pb.go", :exist?
    refute_predicate (testpath/"proto3.pb.go").size, :zero?
  end
end
