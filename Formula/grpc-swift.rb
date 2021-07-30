class GrpcSwift < Formula
  desc "Swift language implementation of gRPC"
  homepage "https://github.com/grpc/grpc-swift"
  url "https://github.com/grpc/grpc-swift/archive/1.3.0.tar.gz"
  sha256 "9d944cb397dfe88cb372c0c4d5095d6eba7f107bdcc3e373ac53b92032e48ac0"
  license "Apache-2.0"
  head "https://github.com/grpc/grpc-swift.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "8c458c0f9cc1c3241a77fbe7c1c040a7382cdd1d44c56f4e11805bf9e0aa1c5b"
    sha256 cellar: :any_skip_relocation, big_sur:       "fd7850786f7d0ade8e78efd516204ac052a15edaf21a7e7ac6fc76fb5cde38a6"
    sha256 cellar: :any_skip_relocation, catalina:      "e20794d763ad566abb787523804cb0a66207800e57e70bf21adfd39bedd73c43"
  end

  depends_on xcode: ["12.0", :build]
  depends_on "protobuf"
  depends_on "swift-protobuf"

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
