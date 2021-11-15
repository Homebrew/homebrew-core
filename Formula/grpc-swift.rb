class GrpcSwift < Formula
  desc "Swift language implementation of gRPC"
  homepage "https://github.com/grpc/grpc-swift"
  url "https://github.com/grpc/grpc-swift/archive/1.5.0.tar.gz"
  sha256 "f182b5f9b0e809b0a56f1b2089b1c9d6da78ace46871ceeebd28d751ac80a5db"
  license "Apache-2.0"
  head "https://github.com/grpc/grpc-swift.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3fec127f5e67589e99c1fb4aa146632512676bfc2de3fa82ddca739ac4cb5e40"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "442e5ec9bbab09b0d5486f9d241cd88369f79a188831e6e2450d885fd213231d"
    sha256 cellar: :any_skip_relocation, monterey:       "b3ef832720781eec5ef6f5fe13f9a8bce3d048d533c4ebaff1361124a312e45a"
    sha256 cellar: :any_skip_relocation, big_sur:        "3e545a1d2751ad6b2dea6369b9da778364b879eb54796044423fb4a2c2d2b245"
    sha256 cellar: :any_skip_relocation, catalina:       "7c6b804c466e2f8d5245e9efd2749c57ece2a4f1dc8f30c2fd88774eaa9dace8"
    sha256                               x86_64_linux:   "24dd2bb28f194eae0629720b07ef4e8fd2f5ad31fd32ba854ab8cbcc63a3ac42"
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
