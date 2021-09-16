class GrpcSwift < Formula
  desc "Swift language implementation of gRPC"
  homepage "https://github.com/grpc/grpc-swift"
  url "https://github.com/grpc/grpc-swift/archive/1.6.1.tar.gz"
  sha256 "40c3701f158b2a19d3920e957fc061f6561ccfabc020fdb9b6da88db710f6c18"
  license "Apache-2.0"
  revision 1
  head "https://github.com/grpc/grpc-swift.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3f8f3744356540643ab4473e6339ac3fad334dfd79965a66217c61d2eac8bf23"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "00e559502ee8a4cac87705a8e783e034f83a1883c0a992221417364e294f69cf"
    sha256 cellar: :any_skip_relocation, monterey:       "70767442a833ab91bbf7cfbd977b746675c2e3cde91ac2c964d3e6d10a7c03c6"
    sha256 cellar: :any_skip_relocation, big_sur:        "96ffcc50c62074f38bc654c54720ac8340b83af2566f3213c1bc56bbb564e9d6"
    sha256 cellar: :any_skip_relocation, catalina:       "94136c3fc31f53e3f0fe235ace6f8a2c4888d92aa9fdbf0b12900838e7970b70"
    sha256                               x86_64_linux:   "b4864b23c84c2584c5a7bb4f3d4f046aee2386a8f7fd11c2cba4139ca640531a"
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
