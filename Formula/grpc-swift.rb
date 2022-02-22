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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4928dd8bdf3ef8aaa3d3cd6fe95dce2df89747fd07570290c828b873e715c8d9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dcc196a0ad0561e8fdd060e4abc84cf11cc86d7aed410678f858524bedf5d9a1"
    sha256 cellar: :any_skip_relocation, monterey:       "9039f0ca7f976fa0883af2690626f213896ef8bceda4a2eb53ac788b6eeba298"
    sha256 cellar: :any_skip_relocation, big_sur:        "0e039f41f787d37849260b5e10299e4fa85c715854b99f52bbd30340623d4aef"
    sha256 cellar: :any_skip_relocation, catalina:       "70581cc4cd3dbab978dae2dcf01bbe2f0e3f352541c574d81abb035d2c786b0c"
    sha256                               x86_64_linux:   "8eb0efbbc839cb09e8922e80be40e1bb0cdf72c121df60845617e189cd5605ab"
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
