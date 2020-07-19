class GrpcSwift < Formula
  desc "The Swift language implementation of gRPC"
  homepage "https://github.com/grpc/grpc-swift"
  url "https://github.com/grpc/grpc-swift/archive/0.11.0.tar.gz"
  sha256 "82e0a3d8fe2b9ee813b918e1a674f5a7c6dc024abe08109a347b686db6e57432"
  license "Apache-2.0"
  head "https://github.com/grpc/grpc-swift.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "c4b65a7ca86cce5a51c4d361f242f3223db64ada30295215636abe6c5e2e6682" => :catalina
    sha256 "44d0cea0079f5b8ead3ae00b5ffe0268424c1b9c894d3f84f9b56e9295cfc4d6" => :mojave
    sha256 "01f53ec401f366d2eedc15b6bf24221443cf3e4728e25891fa87cd89d389efb2" => :high_sierra
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
