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
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "098a666dc2ce663b845fe336c4c791f248c80608340ecf510d99b03778f77a2a"
    sha256 cellar: :any_skip_relocation, big_sur:       "507f74863562cd46608305424d3cd36f2e33019917ee8cf3fd2ad1130b18a3b8"
    sha256 cellar: :any_skip_relocation, catalina:      "b33fb5f38fc738180ea91d22e0661fc14ceb61aae855209ecc767beb69f98d38"
    sha256 cellar: :any_skip_relocation, mojave:        "ccfcae7056ffd927efe0349c068acec723295cf2b259a528905b406bcc70648d"
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
