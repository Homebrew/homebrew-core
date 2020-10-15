class ProtocGenGogofaster < Formula
  desc "Protocol Buffers for Go with Gadgets"
  homepage "https://github.com/gogo/protobuf"
  url "https://github.com/gogo/protobuf/archive/v1.3.1.tar.gz"
  sha256 "5184f06decd681fcc82f6583976111faf87189c0c2f8063b34ac2ea9ed997236"
  license "BSD-3-Clause"
  head "https://github.com/gogo/protobuf.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "00acaa078f3284f87ffdd438be762fd5cb20054b3bfbe9165d9fdf735115f92c" => :catalina
    sha256 "52850416de9fb23a820f7655f47b74633349405d3c2230b68ede71bd1963b4cb" => :mojave
    sha256 "b91c1a5e5effda960a8029b9cbe4855a6e3a7ea8859e06d3237cd87cc12604ed" => :high_sierra
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
