class ProtocGenGogofaster < Formula
  desc "Protocol Buffers for Go with Gadgets"
  homepage "https://github.com/gogo/protobuf"
  url "https://github.com/gogo/protobuf/archive/v1.3.2.tar.gz"
  sha256 "2bb4b13d6e56b3911f09b8e9ddd15708477fbff8823c057cc79dd99c9a452b34"
  license "BSD-3-Clause"
  revision 2
  head "https://github.com/gogo/protobuf.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "905ceb2f46d868e6def2f0863f182708ae67e9349ec93065bfbb361e7d18b1c0"
    sha256 cellar: :any_skip_relocation, big_sur:       "b372763eeb9ffa022ff53859db10a5a61a095dd52e9a61e3430edb8d2d3a2a57"
    sha256 cellar: :any_skip_relocation, catalina:      "04f86e58c4280cc4ef72d28345ba148e79d26196e880afddcaa96771a02fa7d6"
    sha256 cellar: :any_skip_relocation, mojave:        "5b4acdc4e09b6010ec88f1e28db49c74eeb875f0444824f046ea710a9b1798ab"
  end

  depends_on "go" => :build
  depends_on "protobuf"

  def install
    system "go", "build", *std_go_args, "-ldflags", "-s -w", "./protoc-gen-gogofaster"
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
    system "protoc", "--gogofaster_out=.", "proto3.proto"
    assert_predicate testpath/"proto3.pb.go", :exist?
    refute_predicate (testpath/"proto3.pb.go").size, :zero?
  end
end
