class GrpcSwift < Formula
  desc "Swift language implementation of gRPC"
  homepage "https://github.com/grpc/grpc-swift"
  url "https://github.com/grpc/grpc-swift/archive/1.7.0.tar.gz"
  sha256 "aca480a118ba400a2dbaf56a0e1cdce271e37d8874a9a06ff21cb0ea42c6131f"
  license "Apache-2.0"
  head "https://github.com/grpc/grpc-swift.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2fc6be0ea6038ff43b084f85b4768fbf0650f2c0032a3903282b4a50b132013c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7b2a06f346479740cdb34c34f3ef5612ef5c5a590c97068ecb61ef422a24dbae"
    sha256 cellar: :any_skip_relocation, monterey:       "d82fcc299020ab76d98c05fde79d441ec650e944cc46d72dd50223364eaa7355"
    sha256 cellar: :any_skip_relocation, big_sur:        "edc94a047b3394c4dac2653f5191f362919853f83702946c66acd6901102ca03"
    sha256 cellar: :any_skip_relocation, catalina:       "b18a3c14b6c61b5b3c1ae27e4c2085ca577d260ea8eec300994dde23463f40bf"
    sha256                               x86_64_linux:   "579df359e14d7db6f11d8a17dbbd6cd07bb16a15b23fe4ebcae65926384a6993"
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
