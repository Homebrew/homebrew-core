class ProtocGenGrpcSwift < Formula
  desc "Protoc plugin for generating gRPC Swift stubs"
  homepage "https://github.com/grpc/grpc-swift-protobuf"
  url "https://github.com/grpc/grpc-swift-protobuf/archive/refs/tags/2.2.0.tar.gz"
  sha256 "b8b1b7ab4cfaa538b217c55b9a5010e89f5104125886b36303eae45c275d1bc2"
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/grpc/grpc-swift-protobuf.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "24b9717bcfca989ba93137144897c9d4626cc46cae7d444a7f11f67239ad6f82"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a28f0b4aaea8f49fa50c2b9d5c7e3c815043619ff660bc4d99e72bc60fa5744c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9d4b7924a83b94f7e1f1dfba2721a6f6fe61eea90e8c3bb089f4e22438a33e61"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "548bfe6b88bcf7eecdf7fa2ac27b1576a135d4fa676164a6235c989fa7691289"
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
