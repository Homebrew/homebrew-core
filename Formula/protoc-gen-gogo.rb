class ProtocGenGogo < Formula
  desc "Protocol Buffers for Go with Gadgets"
  homepage "https://github.com/gogo/protobuf"
  url "https://github.com/gogo/protobuf/archive/v1.3.2.tar.gz"
  sha256 "2bb4b13d6e56b3911f09b8e9ddd15708477fbff8823c057cc79dd99c9a452b34"
  license "BSD-3-Clause"
  revision 2
  head "https://github.com/gogo/protobuf.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "49b15e28522708155dc3b0aeb3c6218b7d375664dde48e9c462950ea5829422a"
    sha256 cellar: :any_skip_relocation, big_sur:       "a46b71e8f96d10eb734d07eef8a275b535a3604c605c9b520e7d8aad32267af7"
    sha256 cellar: :any_skip_relocation, catalina:      "f87726ce55f06e3ca302f8d90df366db7997ed44c2cb5d29be909129f13c5ea6"
    sha256 cellar: :any_skip_relocation, mojave:        "825ff0c90a2af79858401c668aae6acf85924724f0ec0481d34ec3e50d3c8af2"
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
