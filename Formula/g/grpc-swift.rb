class GrpcSwift < Formula
  desc "Swift language implementation of gRPC"
  homepage "https://github.com/grpc/grpc-swift"
  url "https://github.com/grpc/grpc-swift/archive/refs/tags/1.23.0.tar.gz"
  sha256 "49b8e5c6c47746d4910535ac81e34a2d75541e563078af00da72ded78c9b4f69"
  license "Apache-2.0"
  head "https://github.com/grpc/grpc-swift.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ac7b80a3732e74b2ed8a327841ce21953e5f31b23e667df88976e5b222e13a10"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "175eda7416b1ea2581f63aa1c03d7f82c8ece4435f73379098e5e70e26e0a422"
    sha256 cellar: :any_skip_relocation, sonoma:        "5c5f4fae8d0edf1f1cbd294867031d75daf24c6985777831d1213d9019eb0a99"
    sha256 cellar: :any_skip_relocation, ventura:       "e643ce9036ce268621dee33cce071de8ff288b6074d68c4084e69871bb54ed6f"
    sha256                               x86_64_linux:  "2d41b0d3eb85aac3beb311f475fe59f3fac8dcf4c4fa260e33a768aae6c0f3dd"
  end

  depends_on xcode: ["14.3", :build]
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
