class GrpcSwift < Formula
  desc "Swift language implementation of gRPC"
  homepage "https://github.com/grpc/grpc-swift"
  url "https://github.com/grpc/grpc-swift/archive/1.16.0.tar.gz"
  sha256 "58b60431d0064969f9679411264b82e40a217ae6bd34e17096d92cc4e47556a5"
  license "Apache-2.0"
  head "https://github.com/grpc/grpc-swift.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "abc775bf3f71856aa38de43a0cb7d94e1ffaff325d4a97a9bf7e48b0da09c4ea"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "df7938cd80edd5796cdba69fb7c1b48bc30c740c84819546c6f226ef801209ac"
    sha256 cellar: :any_skip_relocation, ventura:        "a8819db425b3b1d6e2ecc2a9f2b5d31a8071d0dbbaca5f7c294ef61c8468365c"
    sha256 cellar: :any_skip_relocation, monterey:       "0025a6144637cab502b11aae570622d3ace44e2d85e8ce5a2832ca16cd547809"
    sha256                               x86_64_linux:   "a6be8f1ac88e92897ac1c10cff395447d8b38b1e7f31a808273e68b398d8f74e"
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
