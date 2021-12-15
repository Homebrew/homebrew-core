class GrpcSwift < Formula
  desc "Swift language implementation of gRPC"
  homepage "https://github.com/grpc/grpc-swift"
  url "https://github.com/grpc/grpc-swift/archive/1.6.1.tar.gz"
  sha256 "40c3701f158b2a19d3920e957fc061f6561ccfabc020fdb9b6da88db710f6c18"
  license "Apache-2.0"
  head "https://github.com/grpc/grpc-swift.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "90b8187459abcf0dfc5ee94e196aeb5daff6f6b6b6dc2bd6f45e073af01d76bd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0884f22c6c4f2c192df9a0ebf5374df144381d0fd740d98a881e98d21a0b3153"
    sha256 cellar: :any_skip_relocation, monterey:       "b337cebaf53fc1313fc6fbf7c1d6e4a1fa96e0023e316015d5b4b0b8f0fcdbbf"
    sha256 cellar: :any_skip_relocation, big_sur:        "a83c67c8a4d56b50fe143d75548a39dcd99ea432034ae6f4474e4d9b9d0427e5"
    sha256 cellar: :any_skip_relocation, catalina:       "028dc85868746308c824d0aa65602a0848a8de5419b22fe491ab15012705e536"
    sha256                               x86_64_linux:   "d62e5a558da1222f21fc84350a9618aae7501aab2d3a21ae3d24d11e1bbe58b8"
  end

  depends_on xcode: ["12.0", :build]
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
