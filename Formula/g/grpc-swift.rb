class GrpcSwift < Formula
  desc "Swift language implementation of gRPC"
  homepage "https://github.com/grpc/grpc-swift"
  url "https://github.com/grpc/grpc-swift/archive/refs/tags/1.21.0.tar.gz"
  sha256 "675b135443d6fe0c2054ed4c0707576282d8829e2ae50aeaa5b07f2bd84aa6f8"
  license "Apache-2.0"
  head "https://github.com/grpc/grpc-swift.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9fec4b92f07c52c2c9cb65d570e0a3507c2d87a9b52dab3e6efdadfae09016a7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1a17b8fceb072f91349cb95813b9c2246fb9669b94ae57e89429ae2a525d7546"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f82fde5209987ac0dbcb968a4da8d6d3506dbcaf678a901d8b4eece88f2534f6"
    sha256 cellar: :any_skip_relocation, sonoma:         "5532ac1eed0f4398ba8fc62b872e49a0a5ccf71622522bb433e45fdbfe04cbd3"
    sha256 cellar: :any_skip_relocation, ventura:        "7c031aa325b8c7ebfb5adcb18a78c9211f27a2925a42742052c3410012068d56"
    sha256 cellar: :any_skip_relocation, monterey:       "8d03135f0ff4e59a70111a49ab08e218cde498ea9946b6c164a01cde13dcd05a"
    sha256                               x86_64_linux:   "21a2552ffa66fb05050471b3a3229ff32dc86187d609f35d374d40ee4f0580b5"
  end

  depends_on xcode: ["13.3", :build]
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
