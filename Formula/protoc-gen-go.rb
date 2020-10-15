class ProtocGenGo < Formula
  desc "Go support for Google's protocol buffers"
  homepage "https://github.com/golang/protobuf"
  url "https://github.com/golang/protobuf/archive/v1.4.2.tar.gz"
  sha256 "a1e486b3ed6f502c43e10cb28bde4e8f020a420ef9958d3fbe61801492c07c87"
  license "BSD-3-Clause"
  head "https://github.com/golang/protobuf.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "82ce3ce8a8e158bc9202aebfa2cfcbd5b398aeed9530614ece2d101c7e3e01fb" => :catalina
    sha256 "82ce3ce8a8e158bc9202aebfa2cfcbd5b398aeed9530614ece2d101c7e3e01fb" => :mojave
    sha256 "82ce3ce8a8e158bc9202aebfa2cfcbd5b398aeed9530614ece2d101c7e3e01fb" => :high_sierra
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
