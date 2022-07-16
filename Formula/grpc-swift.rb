class GrpcSwift < Formula
  desc "Swift language implementation of gRPC"
  homepage "https://github.com/grpc/grpc-swift"
  url "https://github.com/grpc/grpc-swift/archive/1.8.2.tar.gz"
  sha256 "84643fb635aee686dba1887824de71a04ab5dd38bac9d7fafd1991e8d778c564"
  license "Apache-2.0"
  head "https://github.com/grpc/grpc-swift.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6f44a18eff6ac919275a4385c0259f6fd666d46ead052a425df41abc3538cfe1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "df4863e4318b2dff67b4c5697426130deaf691328998a7b3fa3630c4d216b5bc"
    sha256 cellar: :any_skip_relocation, monterey:       "3d83e564edb05783a830faa14b0e999f0d8b97e7c5681687f880fc803d35758f"
    sha256 cellar: :any_skip_relocation, big_sur:        "f3a7b44727521804f0d89c31187fda62eec5a159e0622e972a69c8ce4ebdcd4a"
    sha256                               x86_64_linux:   "9b24e6565eeab12912d4c9bd8858a992106b1324125f9c9bf64044327d99de84"
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
