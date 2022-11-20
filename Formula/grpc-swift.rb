class GrpcSwift < Formula
  desc "Swift language implementation of gRPC"
  homepage "https://github.com/grpc/grpc-swift"
  url "https://github.com/grpc/grpc-swift/archive/1.13.0.tar.gz"
  sha256 "30e2ff74fa337a22c7f13602a5d3edaeec2d98514fca3d06a7a8df2642498a62"
  license "Apache-2.0"
  head "https://github.com/grpc/grpc-swift.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3194a842e427b2b0d4106d7769274d0a031edfcbd9ca732fc6daa1b461d1e434"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5544a29d48bc7c14174ab2d61544b748a0dc0af6f8b593ffdc5fefc28777b246"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ded73202e740779951c9a85b1b0fe08fa86993fdf83d5e1227f8854ec38322dd"
    sha256 cellar: :any_skip_relocation, ventura:        "fdbbd52b537060e1b97eed4278b6cc741c01e3cdcb67e87c46609e84b8e4253d"
    sha256 cellar: :any_skip_relocation, monterey:       "ad91b84f1b513946fa036633afa8cf5d5a0e9dfbdd74782a594dcc4b2dc3bbef"
    sha256 cellar: :any_skip_relocation, big_sur:        "1735934fae9d2b4a731b4894c8250d5cf25b1dd2c7e38f31f846d229e99420db"
    sha256                               x86_64_linux:   "70d773717d1ea3cf977f81fed48decc8aa1293fb44d1fd31ff36ec409f7b3ff6"
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
