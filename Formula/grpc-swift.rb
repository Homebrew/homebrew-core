class GrpcSwift < Formula
  desc "Swift language implementation of gRPC"
  homepage "https://github.com/grpc/grpc-swift"
  url "https://github.com/grpc/grpc-swift/archive/1.13.2.tar.gz"
  sha256 "d172cd71f5713a1b98bfeffd2acda8e7a99d1addd669abf8f0b4f79f5d4ed6e6"
  license "Apache-2.0"
  head "https://github.com/grpc/grpc-swift.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5067449f21f5da642707a723019f3d845d86376515461f1c9453d10251f38268"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5e2e45311f9dab00bcfb3e05785f979a6a6b14cf93df41016c02e27b83725339"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dd2f37dfe934aa1ddb17b81c8f3f7c7f087e9914b3e8a0f35c027f223df29b1c"
    sha256 cellar: :any_skip_relocation, ventura:        "4b7c4d67481dd8a057a16fc4b660fd77df41e424a84a1a6dd1973d73633a6d17"
    sha256 cellar: :any_skip_relocation, monterey:       "1b1ff01dced5aec3184d86cb5983bfa1cbb9a7ec692e2cda8fbfef37fe9dfc6d"
    sha256 cellar: :any_skip_relocation, big_sur:        "0efcdebd7ab5347e2cb14916c1256e8e31b241b2f583e840a2c549333448f04e"
    sha256                               x86_64_linux:   "fff6c69b264cca90fbcf90b5b58e8baa14e609c4a39b96ae4044c8b537036c50"
  end

  depends_on xcode: ["12.5", :build]
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
