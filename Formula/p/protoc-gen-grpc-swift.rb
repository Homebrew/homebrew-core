class ProtocGenGrpcSwift < Formula
  desc "Protoc plugin for generating gRPC Swift stubs"
  homepage "https://github.com/grpc/grpc-swift-protobuf"
  url "https://github.com/grpc/grpc-swift-protobuf/archive/refs/tags/1.3.0.tar.gz"
  sha256 "0dc2eeb4d04d3909b20d6bcccb79ff828d5a3f800a5f12bca3118828f9dde554"
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/grpc/grpc-swift-protobuf.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a3750dc134f8c2ffdd812b9f16420cd35bf1e48504c0e3c510ff6b0ad9941d20"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2f3cef9ef3de12f5271180a0caed835da583254aefaea90ad00111d8864edae3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8df60e3d84856a1c95e85e8bdc08f8c43a4c41df42eed371e433625fc223a43b"
  end

  depends_on xcode: ["15.0", :build]
  # https://swiftpackageindex.com/grpc/grpc-swift/documentation/grpccore/compatibility#Platforms
  depends_on macos: :sequoia
  depends_on "protobuf"
  depends_on "swift-protobuf"

  uses_from_macos "swift" => :build

  def install
    args = if OS.mac?
      ["--disable-sandbox"]
    else
      ["--static-swift-stdlib"]
    end
    system "swift", "build", *args, "-c", "release", "--product", "protoc-gen-grpc-swift"
    bin.install ".build/release/protoc-gen-grpc-swift"
  end

  test do
    (testpath/"echo.proto").write <<~PROTO
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
    PROTO
    system Formula["protobuf"].opt_bin/"protoc", "echo.proto", "--grpc-swift_out=."
    assert_path_exists testpath/"echo.grpc.swift"
  end
end
