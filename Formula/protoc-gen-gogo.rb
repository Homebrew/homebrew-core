class ProtocGenGogo < Formula
  desc "Protocol Buffers for Go with Gadgets"
  homepage "https://github.com/gogo/protobuf"
  url "https://github.com/gogo/protobuf/archive/v1.3.2.tar.gz"
  sha256 "2bb4b13d6e56b3911f09b8e9ddd15708477fbff8823c057cc79dd99c9a452b34"
  license "BSD-3-Clause"
  head "https://github.com/gogo/protobuf.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "bcdb45abce9f5000c61371677a5ee10f8020a97c07d8535a8fd7dd9f379fccb8" => :big_sur
    sha256 "40c432ee69a489d56783cc90d46aeffcff40130405e74c6203450f31b076a276" => :arm64_big_sur
    sha256 "52cb2b08e10e93d460073d6b5e4a8409dffa67f960e3f876d1440affb8bae746" => :catalina
    sha256 "181fafdedb96ec8bf15b5af14be9dd85ce1d36a60abe8219e68f9cf210e60d0f" => :mojave
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
