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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "af9cd0b58e952134a619e005ae4250642f14e58b559345b96b679b9b6e9c18bf"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "93727dc42b034dd738c07a15e3572a60cf0bace7341056ab9fbfbdcc66c310fc"
    sha256 cellar: :any_skip_relocation, monterey:       "1ea6945f30f3acabb248051ad093f79cf1e07559c8e91693614ad124e8cf532e"
    sha256 cellar: :any_skip_relocation, big_sur:        "b0ecf3dc75ae992d47d9def252e6d28db84d9f877e92a1c188011a8911cf41af"
    sha256                               x86_64_linux:   "07f634b53766c383139812b4be2e703a9a3c07f35a44abc76b7c5ceb63d9e084"
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
