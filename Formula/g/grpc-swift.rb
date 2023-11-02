class GrpcSwift < Formula
  desc "Swift language implementation of gRPC"
  homepage "https://github.com/grpc/grpc-swift"
  url "https://github.com/grpc/grpc-swift/archive/refs/tags/1.20.0.tar.gz"
  sha256 "9b8a5f27c906e0eb6740fd9dcd3e6a74e73e26f925fbfdf78cda26038f765ade"
  license "Apache-2.0"
  head "https://github.com/grpc/grpc-swift.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "567a74108c9793a530ac0ec33994bee54b5df0e56b09ffcedf745fb5b073cc16"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f7f601b1b00dc561a9e32ac1cf8a78843883442acb2bbc91e250934ded8e6914"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1a5513b748150da64688f4fe42d9988fd75d10b3cd8a508af758e913f70233dd"
    sha256 cellar: :any_skip_relocation, sonoma:         "cb1588abf0d394aa89146f978e57ae6ee84ac15145e9b638da7011e12051939c"
    sha256 cellar: :any_skip_relocation, ventura:        "3ab24447bfd3eba155c9847640d2bdd67dd5083fb5fb02dc7a4aa5f74e197975"
    sha256 cellar: :any_skip_relocation, monterey:       "f169f81d7f28b41b44ea876b97e6ea6e9ac71f301dcf83c5969cc7b76f263ce7"
    sha256                               x86_64_linux:   "1300b4c6f69d584204dfa630e7009f70aeacf04101e46201a9753842da3fd449"
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
