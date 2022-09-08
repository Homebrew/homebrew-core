class GrpcSwift < Formula
  desc "Swift language implementation of gRPC"
  homepage "https://github.com/grpc/grpc-swift"
  url "https://github.com/grpc/grpc-swift/archive/1.10.0.tar.gz"
  sha256 "cce2d04a26ab8c606d2da1f3cf732e96e6e68a7e373a4a441b68e0c45755755d"
  license "Apache-2.0"
  head "https://github.com/grpc/grpc-swift.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f8707f495f9f3de586b757c60f922f3089b1847452735434e6f29686bffe9303"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a43fb0a0c1d7d15b6e6f62307ebcc6d4e46fc08abdc246adc1d69b012e7fe670"
    sha256 cellar: :any_skip_relocation, monterey:       "4f895d50b86e197acd7e75be2c1405082676b0ea8dd5d0081e8716e1a28e8c99"
    sha256 cellar: :any_skip_relocation, big_sur:        "81c12794d2242d498830b3fdc9e6e67115d700544cb320d15e1401f02d970dff"
    sha256                               x86_64_linux:   "73ce26fb7c594bcb688ed16dbc58485cf7c4405063b9c2c0398d2e0dc3cc95da"
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
