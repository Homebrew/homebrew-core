class GrpcSwift < Formula
  desc "Swift language implementation of gRPC"
  homepage "https://github.com/grpc/grpc-swift"
  url "https://github.com/grpc/grpc-swift/archive/1.11.0.tar.gz"
  sha256 "5e5534fdfc8f7e7c94c405cde5da93d6aa249a54d62e6885c32d6683d0d54e39"
  license "Apache-2.0"
  head "https://github.com/grpc/grpc-swift.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ecb8e76fe49315d53c5083f8e796983f7e9ba00620dce293784488fb1a8f7846"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "881c6365a2169a55580a0c07ca2b9f210e77ad9fa3c421528d02d633e3156abe"
    sha256 cellar: :any_skip_relocation, monterey:       "e89beff013b4dcfa1d1b638aacff1c78538970c6d6d2308d8eee390c366137db"
    sha256 cellar: :any_skip_relocation, big_sur:        "b123453d2d7dac94fefff62a3909e3baefb1566402d8e0839e8bac8bacf35168"
    sha256                               x86_64_linux:   "69d9ff6d1500f7287b22f5cb89edfe6425760a1b97aac0fcd93cc3219dbe5a07"
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
