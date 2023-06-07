class GrpcSwift < Formula
  desc "Swift language implementation of gRPC"
  homepage "https://github.com/grpc/grpc-swift"
  url "https://github.com/grpc/grpc-swift/archive/1.17.0.tar.gz"
  sha256 "bf2eeb2912d0de655a8c6c5d2db47061f1dce58ae109660ff6fa1fb7cef247a8"
  license "Apache-2.0"
  head "https://github.com/grpc/grpc-swift.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "75f362ce0bd7001099ad54606ee5a10fce4d89a1e4c539bc23b6f952e022b067"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bdf01a700d476b14b4d75c28e43a622daf97610444c621eb572faea78a146f4a"
    sha256 cellar: :any_skip_relocation, ventura:        "b81e2119bc4baae3c37f9b74503f89810b909268e15fe0fef794bc49f9efbcae"
    sha256 cellar: :any_skip_relocation, monterey:       "87f643ca015581b63a5381644849256b3b84a91a776540849c4dafed4b39847c"
    sha256                               x86_64_linux:   "997998f6796a0b0e7dcc3adab4ab098e357a1bdaa6375427ddb518dc9930cc6b"
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
