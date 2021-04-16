class ProtocGenGo < Formula
  desc "Go support for Google's protocol buffers"
  homepage "https://github.com/golang/protobuf"
  url "https://github.com/golang/protobuf/archive/v1.5.2.tar.gz"
  sha256 "088cc0f3ba18fb8f9d00319568ff0af5a06d8925a6e6cb983bb837b4efb703b3"
  license "BSD-3-Clause"
  head "https://github.com/golang/protobuf.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "1b28e0f54bbd31f28a79828b4391b35dd9122b57dfd83444ba32641e9b6a9ed2"
    sha256 cellar: :any_skip_relocation, big_sur:       "6497fdbbd674b2dae0c3d4b810d219e424798a887b6b06b36a13ac7b280ef8c0"
    sha256 cellar: :any_skip_relocation, catalina:      "99c3a3c0b58049eda5a66fecb8638fbef85c9ded1c9d62e302946c15e3b8b8eb"
    sha256 cellar: :any_skip_relocation, mojave:        "02de46104fba48605658ad9a19991699c6f599ee9e9c79c4364da66ef1803bbb"
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
      option go_package = "package/test";
      message Request {
        string name = 1;
        repeated int64 key = 2;
      }
    EOS
    system "protoc", "--go_out=.", "--go_opt=paths=source_relative", "proto3.proto"
    assert_predicate testpath/"proto3.pb.go", :exist?
    refute_predicate (testpath/"proto3.pb.go").size, :zero?
  end
end
