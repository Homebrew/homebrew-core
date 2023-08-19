class GrpcSwift < Formula
  desc "Swift language implementation of gRPC"
  homepage "https://github.com/grpc/grpc-swift"
  url "https://github.com/grpc/grpc-swift/archive/1.19.0.tar.gz"
  sha256 "d266ef96adfa16d286add65e68eda04214ebf2a5a220715f4513e70d4cc0ab1a"
  license "Apache-2.0"
  head "https://github.com/grpc/grpc-swift.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7e397d0d3fbb94f8606f8b5346b0acaf47e61feec01629a1dd41a92fc65eb54a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9bee3532a63fe32b0fa3bb3ce6c5bd833ef2d29d53c498597d6fb6f7fa4ce2ec"
    sha256 cellar: :any_skip_relocation, ventura:        "ab0fb76899255fd86f104734c596e84c6eb1625f01566b7ce0e1dca00259f6a5"
    sha256 cellar: :any_skip_relocation, monterey:       "5bf2aadf534915e8ab32a5d479b4c6e516e152eeaaee4870eac94e22828251d5"
    sha256                               x86_64_linux:   "402845457ca95de4e1e7c9026a829e7a5590a680b828686466d26afa30876759"
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
