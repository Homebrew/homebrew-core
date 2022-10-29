class GrpcSwift < Formula
  desc "Swift language implementation of gRPC"
  homepage "https://github.com/grpc/grpc-swift"
  url "https://github.com/grpc/grpc-swift/archive/1.12.0.tar.gz"
  sha256 "27fd51ff989d2d49185c6f75a201c38c82cfde65767c42af470f388a6f683f99"
  license "Apache-2.0"
  head "https://github.com/grpc/grpc-swift.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "845288dfea676cda82783c4aca76417a7869361b80f134e14d07c2ab66d64b64"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "091df7ca7c7788b0fcf8af7b1767d819924ba4a85349b0a6770ca8f373c1a06d"
    sha256 cellar: :any_skip_relocation, monterey:       "84db3dc29057d76cf37d2f251670bedeb93e56da3c761446b56e4650e0281c94"
    sha256 cellar: :any_skip_relocation, big_sur:        "d78997ff603756e336ccaea9a30130d2c9cdc2a27be4a97b81bd4e82c88cfabc"
    sha256                               x86_64_linux:   "aa5d206faac3323f1b8bd954c24982a51010140ae83484dffa030e776b9cfff8"
  end

  depends_on xcode: ["12.5", :build]
  depends_on "protobuf"
  depends_on "swift-protobuf"

  uses_from_macos "swift"

  def install
    system "swift", "build", "--disable-sandbox", "-c", "release", "--product", "protoc-gen-grpc-swift"
    bin.install ".build/release/protoc-gen-grpc-swift"
  end

  test do
    (testpath/"echo.proto").write <<~EOS
      syntax = "proto3";
      service Echo {
        rpc Get(EchoRequest) returns (EchoResponse) {}
        rpc Expand(EchoRequest) returns (stream EchoResponse) {}
        rpc Collect(stream EchoRequest) returns (EchoResponse) {}
        rpc Update(stream EchoRequest) returns (stream EchoResponse) {}
      }
      message EchoRequest {
        string text = 1;
      }
      message EchoResponse {
        string text = 1;
      }
    EOS
    system Formula["protobuf"].opt_bin/"protoc", "echo.proto", "--grpc-swift_out=."
    assert_predicate testpath/"echo.grpc.swift", :exist?
  end
end
