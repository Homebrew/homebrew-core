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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6b4e051113568d7b1a6bf8faa3eac565c3fd3ef6046afc2958802f2a2ab32cb1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "eb976caf749fe1979d324fa2c4e1d81213b59276f3dc16d95acaac9e9b8c9ebf"
    sha256 cellar: :any_skip_relocation, monterey:       "af474b56b31e1ada9677d902038ff51c5a6e6b8e7e49e4b5c6e3ee9953f6fc8e"
    sha256 cellar: :any_skip_relocation, big_sur:        "f0a2da96c038d7cdd29ed95a3ef6c683fd42eaa75f99e0622212222e1dbe6e47"
    sha256                               x86_64_linux:   "5ad7ccefbb9616a3705ed6ce8edc34e0e6fcea9cc5f3ff9d0814434ac0f1c876"
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
