class ProtocGenGrpcSwift < Formula
  desc "Protoc plugin for generating gRPC Swift stubs"
  homepage "https://github.com/grpc/grpc-swift-protobuf"
  url "https://github.com/grpc/grpc-swift-protobuf/archive/refs/tags/2.5.0.tar.gz"
  sha256 "dc6238a467fe3466477e6509773b0f8fe84a9f58dd97bc39f7fb082e3b222cf6"
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/grpc/grpc-swift-protobuf.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "21d30314c4fac094a6ecb6911dc8718d334878f930a0e7f362096f8d4f1878c0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "196b5a47be2e46144ea958a7c46230845ebe66fb5706370f4a882d72b15fdba4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "1669300e51c9bab8195b7ff0ee8ae07847e0cc62f07d2c0d479fc1a5ac6e3e42"
    sha256 cellar: :any,                 arm64_linux:       "9049ddd123e27830c9cea04ec90560a868a39739999ae72067ac7ef66cb5abf2"
    sha256 cellar: :any,                 x86_64_linux:      "b7b96a3579f31c69eab6df2011d67d7cf74b1cfb799220e9ce220e179226d16f"
  end

  depends_on "protobuf"
  depends_on "swift-protobuf"

  uses_from_macos "swift" => :build

  on_macos do
    depends_on xcode: ["15.0", :build]
    # https://swiftpackageindex.com/grpc/grpc-swift/documentation/grpccore/compatibility#Platforms
    depends_on macos: :sequoia
  end

  def install
    system "swift", "build", "--product", "protoc-gen-grpc-swift-2", *std_swift_args
    bin.install ".build/release/protoc-gen-grpc-swift-2"
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
    system formula_opt_bin("protobuf")/"protoc", "echo.proto", "--grpc-swift-2_out=."
    assert_path_exists testpath/"echo.grpc.swift"
  end
end
