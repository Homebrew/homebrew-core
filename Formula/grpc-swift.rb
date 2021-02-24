class GrpcSwift < Formula
  desc "Swift language implementation of gRPC"
  homepage "https://github.com/grpc/grpc-swift"
  url "https://github.com/grpc/grpc-swift/archive/1.0.0.tar.gz"
  sha256 "5e0258437538bdfa26ca0e023649d97baa138d91881b949b2b344ef84cc2082a"
  license "Apache-2.0"
  head "https://github.com/grpc/grpc-swift.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "ea2436621942aa14bb0b3d3e06af7b6c4cf4d07cbbc9560a9d853a6e7436abda"
    sha256 cellar: :any_skip_relocation, big_sur:       "a11efd7a66968f8f674fa10b659a443885c025f1028c8922d1f39240bb33a38c"
    sha256 cellar: :any_skip_relocation, catalina:      "ad36ba115d8cf3f5fd7095381f3c4faad01d445db061504377b7da23dfececcc"
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
