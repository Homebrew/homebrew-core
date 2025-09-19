class ProtocGenGrpcSwift < Formula
  desc "Protoc plugin for generating gRPC Swift stubs"
  homepage "https://github.com/grpc/grpc-swift-protobuf"
  url "https://github.com/grpc/grpc-swift-protobuf/archive/refs/tags/2.1.1.tar.gz"
  sha256 "7b8302b306cd060e833995a99d1f9c806e7d9eecfcfb8c85c42c928d8abc67f7"
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/grpc/grpc-swift-protobuf.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "62e99816a2642fccde1bbcb2130f0ede39fc14865d2430d33e869f763e06357d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f833d326fff0c5bd0617feb9a083ca2bca268ab258422ab2344ccf9b029e55af"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9987056eef6262da1fb314c171f7a67a8bd37bc0470e3681b83c0e2c4809e855"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b78b922582da46d9564e7f32a15d61b0cb95e3183ab07f7ad5ea38d554faaf46"
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
    system "swift", "build", *args, "-c", "release", "--product", "protoc-gen-grpc-swift-2"
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
    system Formula["protobuf"].opt_bin/"protoc", "echo.proto", "--grpc-swift-2_out=."
    assert_path_exists testpath/"echo.grpc.swift"
  end
end
