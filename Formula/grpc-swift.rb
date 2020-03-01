class GrpcSwift < Formula
  desc "The Swift language implementation of gRPC"
  homepage "https://github.com/grpc/grpc-swift"
  url "https://github.com/grpc/grpc-swift/archive/0.10.0.tar.gz"
  sha256 "dd162909c4dc45c8436744ebb0a0fc90763a496b44e3674dc01dac5ee8e763b9"
  head "https://github.com/grpc/grpc-swift.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "40d3fbbc0193fbc46f029c6c5795ea8bc0faaabe7ea14073a4dc9cb0c98f1c54" => :catalina
    sha256 "f8d66abf01b8b8573b58718a8999ab905619a2b677aa24050dab78e1cd1323de" => :mojave
    sha256 "a8abd068afd441640955a8399ebb07c63228716e6ecd7198258f9e4b92a22e4f" => :high_sierra
  end

  depends_on :xcode => ["10.0", :build]
  depends_on "protobuf"
  depends_on "swift-protobuf"

  def install
    system "swift", "build", "--disable-sandbox", "-c", "release", "--product", "protoc-gen-swiftgrpc"
    bin.install ".build/release/protoc-gen-swiftgrpc"
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
    system Formula["protobuf"].opt_bin/"protoc", "echo.proto", "--swiftgrpc_out=."
    assert_predicate testpath/"echo.grpc.swift", :exist?
  end
end
