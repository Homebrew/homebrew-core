class ProtocGenGogofaster < Formula
  desc "Protocol Buffers for Go with Gadgets"
  homepage "https://github.com/gogo/protobuf"
  url "https://github.com/gogo/protobuf/archive/v1.3.2.tar.gz"
  sha256 "2bb4b13d6e56b3911f09b8e9ddd15708477fbff8823c057cc79dd99c9a452b34"
  license "BSD-3-Clause"
  head "https://github.com/gogo/protobuf.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "f7d48a601b42a51ce9982cad4772a66a410602a64a15856cc2a704fc9275e647" => :big_sur
    sha256 "01ca1d04d4ee1a33e038345a6ab7208edafa046485237ff2890bf1f203a68968" => :arm64_big_sur
    sha256 "454929acb01ffbc0f4f641388d3986a960d03dc92a566b89c42876bf42076fb3" => :catalina
    sha256 "f57cfc59528edcafc8daebae58f5b82084ca9710429a25926830adc6a5573f57" => :mojave
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
