class GrpcSwift < Formula
  desc "Swift language implementation of gRPC"
  homepage "https://github.com/grpc/grpc-swift"
  url "https://github.com/grpc/grpc-swift/archive/1.19.1.tar.gz"
  sha256 "e9d6e2982415819291fdcbd06495fb5a518463a9afa45a93b5f6dfa9b42b0a61"
  license "Apache-2.0"
  head "https://github.com/grpc/grpc-swift.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "389c945929fefea2f9cfbfe108fa9e60807a056b95034ddc3df6c2a221c6d60c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0ce373355f11b88f25305b0d37448dc2a93d88cd08f7e2a3f4931676f92970de"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "25104d55f83d942c3b66d768b8ef90d10b762349ad6e1728afbec7b6e14c49d8"
    sha256 cellar: :any_skip_relocation, sonoma:         "21d09392eeafbfe9cb691e172c91a4c88476b65020b50fdd205c9fd44fa28bce"
    sha256 cellar: :any_skip_relocation, ventura:        "e9c003e180cd041127ca8bfe6c3073bc70d77aac1ccbfbfe07de0d5d1cf25cce"
    sha256 cellar: :any_skip_relocation, monterey:       "df4647a9eff09a556046a1cd6eec6234e896ba20e88b97f0f6ab8bb8b2ae1581"
    sha256                               x86_64_linux:   "911a5c41724a81cfb5607502a26ca7bfaf563dc0124b1af3b662e4fbc5ccfd40"
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
