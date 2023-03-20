class GrpcSwift < Formula
  desc "Swift language implementation of gRPC"
  homepage "https://github.com/grpc/grpc-swift"
  url "https://github.com/grpc/grpc-swift/archive/1.14.2.tar.gz"
  sha256 "f4bf6272aff13426e6b1d7e00b3a283a505a1be5ae432b4584a9aae3d74f3672"
  license "Apache-2.0"
  head "https://github.com/grpc/grpc-swift.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ba4f4ed6d980ce9a96d166e6f1c468fca376b0f32a5d86a1e3bcc171ec4a67ba"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1c23f79e260fb8d78b99cc7cdb82774257806e9fe041e0bc8cd8dc90cdacc233"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b4d6069cc7bb41ee4d94df1d801abbaa405657474c974431cabe0adeb06d13e3"
    sha256 cellar: :any_skip_relocation, ventura:        "ecf30dd4fb33c4b2e2ca40f4159b9e853a6f60af9e7bc8ec36a807dbb43cbfae"
    sha256 cellar: :any_skip_relocation, monterey:       "1e7665c04c78545f03cadcfd3fb562f98e8a3af00d4cc484a620f5ddd43eeb11"
    sha256 cellar: :any_skip_relocation, big_sur:        "8f02798c7bee3dbb81ece78074caf70310133a5dca6d9dd289815d02583f38ff"
    sha256                               x86_64_linux:   "c6b51fe0693fb1ae088419aeda5596338cd539ff1c2f438d65334a6e572478b0"
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
