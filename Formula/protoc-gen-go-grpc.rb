class ProtocGenGoGrpc < Formula
  desc "Protoc plugin that generates code for gRPC-Go clients"
  homepage "https://github.com/grpc/grpc-go"
  url "https://github.com/grpc/grpc-go/archive/cmd/protoc-gen-go-grpc/v1.1.0.tar.gz"
  sha256 "9aa1f1f82b45a409c25eb7c06c6b4d2a41eb3c9466ebd808fe6d3dc2fb9165b3"
  license "Apache-2.0"
  revision 2

  livecheck do
    url :stable
    regex(%r{cmd/protoc-gen-go-grpc/v?(\d+(?:\.\d+)+)}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9df609a95b094515a048eba3d1621d6c15a156a72b8cecf94b06caf1df9f46a5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ad604447808fa88d386c5864726985220ec03a5cb7dd17f2c8deb1de3b1ba86e"
    sha256 cellar: :any_skip_relocation, monterey:       "6e8af04c3d408dd6312792a3f4eed2ce511846debbe83c4145b644e5d283b2da"
    sha256 cellar: :any_skip_relocation, big_sur:        "c288d0096bfeff80418f468a0a1c92aaa43dd31f62a3e2f37f14ad5577ebbcc8"
    sha256 cellar: :any_skip_relocation, catalina:       "c288d0096bfeff80418f468a0a1c92aaa43dd31f62a3e2f37f14ad5577ebbcc8"
    sha256 cellar: :any_skip_relocation, mojave:         "c288d0096bfeff80418f468a0a1c92aaa43dd31f62a3e2f37f14ad5577ebbcc8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dd8411b9523d4ece4a2ce08e2be463ec09b2873f50a5c46744420962a0a2f8fb"
  end

  depends_on "go" => :build
  depends_on "protobuf"

  def install
    cd "cmd/protoc-gen-go-grpc" do
      system "go", "build", *std_go_args
    end
  end

  test do
    (testpath/"service.proto").write <<~EOS
      syntax = "proto3";

      option go_package = ".;proto";

      service Greeter {
        rpc Hello(HelloRequest) returns (HelloResponse);
      }

      message HelloRequest {}
      message HelloResponse {}
    EOS

    system "protoc", "--plugin=#{bin}/protoc-gen-go-grpc", "--go-grpc_out=.", "service.proto"

    assert_predicate testpath/"service_grpc.pb.go", :exist?
  end
end
