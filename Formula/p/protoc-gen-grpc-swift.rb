class ProtocGenGrpcSwift < Formula
  desc "Protoc plugin for generating gRPC Swift stubs"
  homepage "https://github.com/grpc/grpc-swift-protobuf"
  url "https://github.com/grpc/grpc-swift-protobuf/archive/refs/tags/2.4.0.tar.gz"
  sha256 "f4f35648d1055319bd6caad1b7894017c9c546727968b8e9f3b4357fcb809d23"
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/grpc/grpc-swift-protobuf.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3367f57af6aacc55a89eff8326363caf4a18d2b7f4fe4432f87543ac9508e23e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "39f2f2c3afcd2de0277269ef6791461ca8156de7d81e4617680f230c089b2756"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "169044473695b6a062f1568c51313ff57ad22fcc67443189224cbb17c55791aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3ce18aa9cb49311aef00f7568edf746a0ad492b763e7dff69a199a0a96095fb6"
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
    system Formula["protobuf"].opt_bin/"protoc", "echo.proto", "--grpc-swift-2_out=."
    assert_path_exists testpath/"echo.grpc.swift"
  end
end
