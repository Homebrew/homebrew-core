class GrpcSwift < Formula
  desc "Swift language implementation of gRPC"
  homepage "https://github.com/grpc/grpc-swift"
  url "https://github.com/grpc/grpc-swift/archive/1.1.1.tar.gz"
  sha256 "ec703946c1f9d379ed9d910333f27eed4d1bc58e887849186802f951b9e9448b"
  license "Apache-2.0"
  head "https://github.com/grpc/grpc-swift.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "79ace37e7a57b0d8b475bd4d151950ede41c44bd8ed5def7f6ec2fa3872ab66f"
    sha256 cellar: :any_skip_relocation, big_sur:       "fc0cad5b1c3caff003eb838b7cc37032f9f7416c823941f304a09705f5bab174"
    sha256 cellar: :any_skip_relocation, catalina:      "8a1ee1b56aae8427016a3f9a5b0c62ad2e7808ed5104f71e735b4bdb54f6221d"
  end

  depends_on xcode: ["12.0", :build]
  depends_on "protobuf"
  depends_on "swift-protobuf"

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
