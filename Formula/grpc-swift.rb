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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "59ff880475ae40318a36eb15332523631720d57453c0b4f43164cc6b347a4873"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c4793e839f0dfeba421943f98bf3b1a9f3f1f9c286d7ac54ea3cd1937ab6b438"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "03b090ead52590336efed9a69b3bb1288adf5ab17cf6305d700c7a2004c9a2f0"
    sha256 cellar: :any_skip_relocation, ventura:        "9edd651c177b4c9d0b7d3276258b2e27fabc15e43603d9299516b1c38a51695a"
    sha256 cellar: :any_skip_relocation, monterey:       "31b94a7875afa62966aa942b82a8861507e8f22251baeab893d6b1bd949c00ab"
    sha256 cellar: :any_skip_relocation, big_sur:        "ed341e01aef4e5755ad8b59b2e4054b12e1edee41cda01f9e7b6b283923f415d"
    sha256                               x86_64_linux:   "61d475a6657b81947c334fb9be8162b64a910e7730082df7fc64d915f2026f65"
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
