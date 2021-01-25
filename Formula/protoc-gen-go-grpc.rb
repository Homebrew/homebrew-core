class ProtocGenGoGrpc < Formula
  desc "Protoc plugin that generates code for gRPC-Go clients"
  homepage "https://github.com/grpc/grpc-go"
  url "https://github.com/grpc/grpc-go/archive/cmd/protoc-gen-go-grpc/v1.1.0.tar.gz"
  sha256 "9aa1f1f82b45a409c25eb7c06c6b4d2a41eb3c9466ebd808fe6d3dc2fb9165b3"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(%r{cmd/protoc-gen-go-grpc/v?(\d+(?:\.\d+)+)}i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "550862edce2e052702a1366ae8ce5845c2acb675f4a4641cf73f827cb3d10266" => :big_sur
    sha256 "c47542375b001e0898ddd340396d2f8fbb07dbdec508f88c6c250b3dc8fde162" => :arm64_big_sur
    sha256 "da0adc9a5ddea5cf165ef323fa1920d7dabf57d907dc588051bad0c73e027cf3" => :catalina
    sha256 "f6425e837c199ee3569ac6c8e59714dcc96ffc1578e02ded11ec9a28cbc29136" => :mojave
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
