class GrpcSwift < Formula
  desc "The Swift language implementation of gRPC"
  homepage "https://github.com/grpc/grpc-swift"
  url "https://github.com/grpc/grpc-swift/archive/0.10.0.tar.gz"
  sha256 "dd162909c4dc45c8436744ebb0a0fc90763a496b44e3674dc01dac5ee8e763b9"
  head "https://github.com/grpc/grpc-swift.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "e0797863606102081bef338113fe59e92c0dc1e94076b5d2f7d8dc228604ecb9" => :catalina
    sha256 "41cd40af49f7f7dd68fd65e74f6a6e33cee1bad1bdaa91cb82097b3f88b1f71c" => :mojave
    sha256 "1b0d72d9130ed12f2cce93a7f7e4be7ad8d36ccc68167d949f4e01f46ee85942" => :high_sierra
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
