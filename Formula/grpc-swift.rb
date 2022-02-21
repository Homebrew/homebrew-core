class GrpcSwift < Formula
  desc "Swift language implementation of gRPC"
  homepage "https://github.com/grpc/grpc-swift"
  url "https://github.com/grpc/grpc-swift/archive/1.7.1.tar.gz"
  sha256 "d42f2ef08d478ad2f21b578f93d72263346c52aef81fc7a88605254fd9098171"
  license "Apache-2.0"
  head "https://github.com/grpc/grpc-swift.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "77697ccfecfec4d597ffe56d2162aa69d138dbe8823c0aa9ac72ae3129edf553"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f1edc7d61c0543c03d3d0f656a5a684b3ca986eb3c10881cec6fb85dcf5d240e"
    sha256 cellar: :any_skip_relocation, monterey:       "2adcc942b55bc2c03809aa91f5cb1dfdda1c5fb8f82a76b77079c94c0b09a023"
    sha256 cellar: :any_skip_relocation, big_sur:        "a4b53f9ee0671de6f3f0983f8fabe61810fae028039e04927a6e31d62d85f102"
    sha256 cellar: :any_skip_relocation, catalina:       "f3f3cc52044532029f50c4084b5875ea70e13454329e8a411cda07828f198dfe"
    sha256                               x86_64_linux:   "d2cd2096e399a1d72a1d279f114754c85115ece0c1d5f0281cd81ec88c3c6fcf"
  end

  depends_on xcode: ["12.0", :build]
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
