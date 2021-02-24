class ProtocGenGogofaster < Formula
  desc "Protocol Buffers for Go with Gadgets"
  homepage "https://github.com/gogo/protobuf"
  url "https://github.com/gogo/protobuf/archive/v1.3.2.tar.gz"
  sha256 "2bb4b13d6e56b3911f09b8e9ddd15708477fbff8823c057cc79dd99c9a452b34"
  license "BSD-3-Clause"
  head "https://github.com/gogo/protobuf.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "97fa5530e2802b51f8726430ed1e9d7036f5e5f5a0d85e8a7d50765b872e8dd6"
    sha256 cellar: :any_skip_relocation, big_sur:       "621fee518b14608926125eef6a329bd81a700e17e9e2aad80784bb0ecfda5ba5"
    sha256 cellar: :any_skip_relocation, catalina:      "2577dd0c7a96a4d93d43159941751a8db1067b34c5c0dff06b3b4fcafc232259"
    sha256 cellar: :any_skip_relocation, mojave:        "f735e8e476623627f928fd62e77aff6d67c60342d1371ed49c9bc28d040e3146"
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
