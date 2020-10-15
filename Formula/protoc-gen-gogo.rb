class ProtocGenGogo < Formula
  desc "Protocol Buffers for Go with Gadgets"
  homepage "https://github.com/gogo/protobuf"
  url "https://github.com/gogo/protobuf/archive/v1.3.1.tar.gz"
  sha256 "5184f06decd681fcc82f6583976111faf87189c0c2f8063b34ac2ea9ed997236"
  license "BSD-3-Clause"
  head "https://github.com/gogo/protobuf.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "9be4c48be2450104703311eadf0457869f0a933602c18918c794cd4f17430349" => :catalina
    sha256 "bce62f3a9c17de2c649863d5416bbb1a4ba2ded03804b79e1de1515f716a86aa" => :mojave
    sha256 "334e9a6d6e8dea847e217326944503a154614134e6c74a522cccdb9ef4051478" => :high_sierra
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
