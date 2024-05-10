class ProtocGenGogofaster < Formula
  desc "Protocol Buffers for Go with Gadgets"
  homepage "https://github.com/gogo/protobuf"
  url "https://github.com/gogo/protobuf/archive/refs/tags/v1.3.2.tar.gz"
  sha256 "2bb4b13d6e56b3911f09b8e9ddd15708477fbff8823c057cc79dd99c9a452b34"
  license "BSD-3-Clause"
  revision 2
  head "https://github.com/gogo/protobuf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "431013b7d133ac74d5ff547246f2bc641936067d1b10eb4b93ad015032836661"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1f4e5870fa91ee6e996ce3e245e8034b5f6f4f8c6db9dd1f5c8ede89ed9fd58c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "378b53c4119a446426fbb9ef36b571f1c7bd97a4e4c97b6267b7760caa12d060"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "55f33ac4a991f8e935b7d86d9fbe73f0df950548844a2cead274b02376483990"
    sha256 cellar: :any_skip_relocation, sonoma:         "80bf98c195f950e1e8116219cf5b2d6f06733ca37466d0a0572093b3fd9eaa8d"
    sha256 cellar: :any_skip_relocation, ventura:        "e71b696d1283ace865581017660a03b96ccca94a4c178adab8c44eecabd344b2"
    sha256 cellar: :any_skip_relocation, monterey:       "816053916d093c0d7f5d8f11e6720e5dfb01c5123a1c2bfee00625b463791e8b"
    sha256 cellar: :any_skip_relocation, big_sur:        "6fba8cafcb5492731cf7ef4916cd4dcf60863f51db329b13dd9549a1082f196b"
    sha256 cellar: :any_skip_relocation, catalina:       "6fba8cafcb5492731cf7ef4916cd4dcf60863f51db329b13dd9549a1082f196b"
    sha256 cellar: :any_skip_relocation, mojave:         "6fba8cafcb5492731cf7ef4916cd4dcf60863f51db329b13dd9549a1082f196b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a75f5bb389047f9b9086864ebeab5d95c8e415a0603543c19413b614293aeb04"
  end

  # gogoprotobuf is officially deprecated:
  # https://github.com/gogo/protobuf/commit/f67b8970b736e53dbd7d0a27146c8f1ac52f74e5
  disable! date: "2024-02-15", because: :deprecated_upstream

  depends_on "go" => :build
  depends_on "protobuf"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./protoc-gen-gogofaster"
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
