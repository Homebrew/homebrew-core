class GrpcSwift < Formula
  desc "Swift language implementation of gRPC"
  homepage "https://github.com/grpc/grpc-swift"
  url "https://github.com/grpc/grpc-swift/archive/1.3.0.tar.gz"
  sha256 "9d944cb397dfe88cb372c0c4d5095d6eba7f107bdcc3e373ac53b92032e48ac0"
  license "Apache-2.0"
  head "https://github.com/grpc/grpc-swift.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "ba2ea3cb5eac186c74dc2c3cb52a4778d8165d0722f9255db46652a3d4bf68d1"
    sha256 cellar: :any_skip_relocation, big_sur:       "d07dc821fe534041914a14be3ff9d64ccfcc20cdd01f50e60b7b9512104b0689"
    sha256 cellar: :any_skip_relocation, catalina:      "f5bfa9de8d2b0ad1cc7fa93dfdb6a6ea7a08960d2c7f7dd221e0d3f1ff3bcb4b"
    sha256                               x86_64_linux:  "66ae7bf6da9d9fb4383955fcae4ac382dc6a88b194c4e0263c429f43b9ddd389"
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
