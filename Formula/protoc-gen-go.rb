class ProtocGenGo < Formula
  desc "Go support for Google's protocol buffers"
  homepage "https://github.com/protocolbuffers/protobuf-go"
  url "https://github.com/protocolbuffers/protobuf-go/archive/v1.27.0.tar.gz"
  sha256 "5a928abfdcc7972e92738e7af2b8d1a41f4b2b7511d5b4f4f5b1ce3705668f45"
  license "BSD-3-Clause"
  head "https://github.com/protocolbuffers/protobuf-go.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "d3d308a1e5375a62fe27fa5377b46cb7523144297911c574c80c35774ce31d5b"
    sha256 cellar: :any_skip_relocation, big_sur:       "85c47dfa6ae56aae8ca5d3b36275884b0dafe749acf178d11a5b4ba6e28bb1b8"
    sha256 cellar: :any_skip_relocation, catalina:      "85c47dfa6ae56aae8ca5d3b36275884b0dafe749acf178d11a5b4ba6e28bb1b8"
    sha256 cellar: :any_skip_relocation, mojave:        "85c47dfa6ae56aae8ca5d3b36275884b0dafe749acf178d11a5b4ba6e28bb1b8"
  end

  depends_on "go" => :build
  depends_on "protobuf"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/protoc-gen-go"
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
