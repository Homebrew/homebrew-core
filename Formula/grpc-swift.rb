class GrpcSwift < Formula
  desc "Swift language implementation of gRPC"
  homepage "https://github.com/grpc/grpc-swift"
  url "https://github.com/grpc/grpc-swift/archive/1.15.0.tar.gz"
  sha256 "cfe6dd36859a56f3430a2a19a799891e797e66f16452d765263749c0a05eba87"
  license "Apache-2.0"
  head "https://github.com/grpc/grpc-swift.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "19aa73a2fbef5dd1d00facf9dfa6496809ca60969bd49ee7da88905e220073f1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2de2172dd708c201c8ad810a7238c854c0254921b273afe3121901cee2d68cf4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "79bcbeb723973b3c6f3b56ea4c78ac56407717d9cc96b35a47835e993f1040ef"
    sha256 cellar: :any_skip_relocation, ventura:        "497c6eee4b73ecabb5de4dc6bfc4f1f94919083ccc266ac7fa7685e6aa44559a"
    sha256 cellar: :any_skip_relocation, monterey:       "381e1b61e24493c218b8c08961e1c63816b21d23f45a1505a0f76349a554ca5a"
    sha256 cellar: :any_skip_relocation, big_sur:        "9cb8175bc102157c32a3c6445337b69e3850f51423aa04051cf440ccaebc04ed"
    sha256                               x86_64_linux:   "5286379e75b4f9e50038c95b791f7e611f5e1dcc186bd7abea14d85a1cfce484"
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
