class ProtocGenGrpcSwift < Formula
  desc "Protoc plugin for generating gRPC Swift stubs"
  homepage "https://github.com/grpc/grpc-swift-protobuf"
  url "https://github.com/grpc/grpc-swift-protobuf/archive/refs/tags/2.4.1.tar.gz"
  sha256 "536c1b0c5dfe8efa604c30bb2b831b49e765aa212b1180acda3d630714187197"
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/grpc/grpc-swift-protobuf.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b8c3a6c8fd5e886b9591ff14ace6550d3528aacdf8efed0c007d2cca48b0ee76"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e1d39336fb77fe9f1629c6366e913e622d5abab95f4ba21f1fbc880fc1c45253"
    sha256 cellar: :any,                 arm64_linux:   "11dda0c6f5cbc0b3dabe608102e67608743d769d0115a9c2cf93d3cfba845d39"
    sha256 cellar: :any,                 x86_64_linux:  "832640c9a2330cd61e4c385ae2a1eaa29646d71dee3d97c22f526ec4bc0fb919"
  end

  depends_on xcode: ["15.0", :build]
  depends_on "protobuf"
  depends_on "swift-protobuf"

  uses_from_macos "swift" => :build

  on_macos do
    # https://swiftpackageindex.com/grpc/grpc-swift/documentation/grpccore/compatibility#Platforms
    depends_on macos: :sequoia
  end

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
    system formula_opt_bin("protobuf")/"protoc", "echo.proto", "--grpc-swift-2_out=."
    assert_path_exists testpath/"echo.grpc.swift"
  end
end
