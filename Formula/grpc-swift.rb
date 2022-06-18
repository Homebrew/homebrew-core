class GrpcSwift < Formula
  desc "Swift language implementation of gRPC"
  homepage "https://github.com/grpc/grpc-swift"
  url "https://github.com/grpc/grpc-swift/archive/1.8.0.tar.gz"
  sha256 "994da474a5614333c2e3fa52f2bf69871c037fcc85f5b95bdaa62a42d240d8d3"
  license "Apache-2.0"
  head "https://github.com/grpc/grpc-swift.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "674d49d21bbfccaa8993f2b16418f86e468806cb0b13d59d17218efe0ce35718"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2c37e18c1c408d0fc07d1c95b59d85f84d6892d79a6ba1a1696f94bf2b096d79"
    sha256 cellar: :any_skip_relocation, monterey:       "79ea06f6257713f4db45a251671576cc657194d186f2b70c84215650134eeb90"
    sha256 cellar: :any_skip_relocation, big_sur:        "1c6c64eaf6282d6b82087f10d63fd9d69ad63f92f2cc198ce2854b3b87ccba8b"
    sha256 cellar: :any_skip_relocation, catalina:       "1e30789c40b90fe40bfc7f04a6167a07807d7f157616367b3a3bb41d4b3192ed"
    sha256                               x86_64_linux:   "5faad1ff5ff2a40e57abd972d5f951f7d41f50a874e4a21252bd3f5e73e9736d"
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
