class GrpcSwift < Formula
  desc "Swift language implementation of gRPC"
  homepage "https://github.com/grpc/grpc-swift"
  url "https://github.com/grpc/grpc-swift/archive/1.0.0.tar.gz"
  sha256 "5e0258437538bdfa26ca0e023649d97baa138d91881b949b2b344ef84cc2082a"
  license "Apache-2.0"
  revision 2
  head "https://github.com/grpc/grpc-swift.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "22440b3a2ff559632a24a44cb771fa139539b88f9e6f26452dce50ff3edf1ab3"
    sha256 cellar: :any_skip_relocation, big_sur:       "fed1082954d27441ece55363cfffed39587607844917ec1f4609d17b8779af76"
    sha256 cellar: :any_skip_relocation, catalina:      "7c308662e00445b7788de6f5262175e40df63db599a42e2b40fa9ea48df4a4de"
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
