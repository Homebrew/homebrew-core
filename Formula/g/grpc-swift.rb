class GrpcSwift < Formula
  desc "Swift language implementation of gRPC"
  homepage "https://github.com/grpc/grpc-swift"
  url "https://github.com/grpc/grpc-swift/archive/refs/tags/1.21.1.tar.gz"
  sha256 "e012013495d2b06bf141a3cf3fade2f5a71118e0afc180c6c471fa96060e6aa5"
  license "Apache-2.0"
  head "https://github.com/grpc/grpc-swift.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "39047658c916e9639ece5c2a0a9b83cdd09852edb5c2d48516029e403a1b181d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c5f15f02971ad07545116056b11914e145f2ede9c77cb92d63dc846d39fb56f8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c4b3d1775e1a3afc148e42c50385d667eab8dd63c76a6a555fee1bee3dba9425"
    sha256 cellar: :any_skip_relocation, sonoma:         "759366715997de7d2790203596a4b868da37ae374c56418edaa4fe6e8772f56c"
    sha256 cellar: :any_skip_relocation, ventura:        "5a3a5e89d5274a5e669490f0966bdaddb45fc552ce5db69fdd849c0f4a3c5e8e"
    sha256 cellar: :any_skip_relocation, monterey:       "96d9981ae6bc5abfbb351c236c2130a32dd131e4d60effe4c051eab73adf71e1"
    sha256                               x86_64_linux:   "0d1eae3a29443a027cc0c77b03552aa5aaa40809149468f5cfcecf628621770f"
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
