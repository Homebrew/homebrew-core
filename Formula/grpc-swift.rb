class GrpcSwift < Formula
  desc "Swift language implementation of gRPC"
  homepage "https://github.com/grpc/grpc-swift"
  url "https://github.com/grpc/grpc-swift/archive/1.0.0.tar.gz"
  sha256 "5e0258437538bdfa26ca0e023649d97baa138d91881b949b2b344ef84cc2082a"
  license "Apache-2.0"
  revision 1
  head "https://github.com/grpc/grpc-swift.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "4aec72603988813a29c088629f28cf91d4d9f09431905b59982d07da34a994e4"
    sha256 cellar: :any_skip_relocation, big_sur:       "fa1bbadcaaf9feafa4277450a3bce9e299ff8c92bb4ef7a94c8d247e6a35da6c"
    sha256 cellar: :any_skip_relocation, catalina:      "2e5d7811571ca3744cf8caeb836cf37ae1c802d7aff3a96c1126db1513df0c57"
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
