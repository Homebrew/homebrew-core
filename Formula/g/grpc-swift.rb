class GrpcSwift < Formula
  desc "Swift language implementation of gRPC"
  homepage "https://github.com/grpc/grpc-swift"
  url "https://github.com/grpc/grpc-swift/archive/refs/tags/1.24.1.tar.gz"
  sha256 "812151aeb48e23ded71bdb9b4dc5a46428d97e85743881a79d6b4a9ae4578fd3"
  license "Apache-2.0"
  head "https://github.com/grpc/grpc-swift.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e4dc8ad6cf0c3dd65b58f5676876a549d14c78a29eb3c02f7c206bc24a0a12a4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "83c7cbb82d1857e0dc9217d16b062a0d45c0cb9892d8194c80089479a43e6da5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d0dc41716535f7ab3958ed0c67543985208e8dab929ef16787bb9a325d514226"
    sha256 cellar: :any_skip_relocation, sonoma:        "98d18a37f875e8baeb96369515cbec04ede1da3b26db873c66b8441e43c9c055"
    sha256 cellar: :any_skip_relocation, ventura:       "dddd2ce02fa6854932505a6f04dd38afaad7ade396b8887401d163b9f2558353"
    sha256                               x86_64_linux:  "c861807c9e2678d0cd9a1efde6fafb33dd9699470eb77731a57d1efed9c8b924"
  end

  depends_on xcode: ["14.3", :build]
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
