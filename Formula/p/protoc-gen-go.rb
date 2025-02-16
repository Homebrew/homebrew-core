class ProtocGenGo < Formula
  desc "Go support for Google's protocol buffers"
  homepage "https://github.com/protocolbuffers/protobuf-go"
  url "https://github.com/protocolbuffers/protobuf-go/archive/refs/tags/v1.36.5.tar.gz"
  sha256 "a669a85f92c229768e51877c6ed9b2c7d33c31ab089345b616dd3da1d815534d"
  license "BSD-3-Clause"
  head "https://github.com/protocolbuffers/protobuf-go.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b8f0c4382c3732c1c486021281a2ba2006a429cd6b8dc3b1ed366b9a9c94b74c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b8f0c4382c3732c1c486021281a2ba2006a429cd6b8dc3b1ed366b9a9c94b74c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b8f0c4382c3732c1c486021281a2ba2006a429cd6b8dc3b1ed366b9a9c94b74c"
    sha256 cellar: :any_skip_relocation, sonoma:        "3c9cebcb42d76762cb4b6f6c1ee5fa11239f43baed9addd8ea6190fc82b07eb5"
    sha256 cellar: :any_skip_relocation, ventura:       "3c9cebcb42d76762cb4b6f6c1ee5fa11239f43baed9addd8ea6190fc82b07eb5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "52cb6790731457df31d65eed0104e3104cec93b2507b8124283ea1638532f675"
  end

  depends_on "go" => :build
  depends_on "protobuf"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/protoc-gen-go"
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
    assert_path_exists testpath/"proto3.pb.go"
    refute_predicate (testpath/"proto3.pb.go").size, :zero?
  end
end
