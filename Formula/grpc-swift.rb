class GrpcSwift < Formula
  desc "Swift language implementation of gRPC"
  homepage "https://github.com/grpc/grpc-swift"
  url "https://github.com/grpc/grpc-swift/archive/1.14.0.tar.gz"
  sha256 "643109e821be5097082a618b11f0fa6d57f858680d86e88a0e390e94fb85f21d"
  license "Apache-2.0"
  head "https://github.com/grpc/grpc-swift.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d41bac96c2a407b3f30cea30e2fed7da7dd2416aa1ae11fffd42d9e9061f2582"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b6d37178b53ba96011afce4f8e60fb47b1f2d0bd882dd42e4c85c4f3f5597845"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "45ea425aa98449934dc426dff8fd50a9e69eec6367dc9aac4bf61d4a2ced2229"
    sha256 cellar: :any_skip_relocation, ventura:        "f568babea8022a02fec074687853516b9f03d9599efdda29c4c9b14dcc8ff378"
    sha256 cellar: :any_skip_relocation, monterey:       "572ced424b97f16568a13de54fbfb36234d461465455daf4e934d0fc596c547d"
    sha256 cellar: :any_skip_relocation, big_sur:        "74a3b7f9ccd47d27f5b18033b61c167a9a93a7ce236c51cbecdc10bb55e248a3"
    sha256                               x86_64_linux:   "126f9732dc3132eefee0a3f097ba5f1edd600b23caaef3a7dc06f6c62d2c376b"
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
