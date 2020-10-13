class ProtocGenGoGrpc < Formula
  desc "Protoc plugin that generates code for gRPC-Go clients"
  homepage "https://github.com/grpc/grpc-go"
  url "https://github.com/grpc/grpc-go/archive/cmd/protoc-gen-go-grpc/v1.0.0.tar.gz"
  sha256 "488bb2b4b282b7d4adda32a6534268b2622990d59e2bdadd6f28603638f07116"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(%r{cmd/protoc-gen-go-grpc/v?(\d+(?:\.\d+)+)}i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "46920c9b75eaf0f473e61865d391b7fb753253f050865ecd856509e06f2b71ea" => :catalina
    sha256 "9634dcccbd06eaa037d88e4d647845684c7fbdb72564a889a3a856c663a0e150" => :mojave
    sha256 "7a42ddf7f4827de9a1c8548ec0db496ffb665520a8ec10839461db2a1bf10c74" => :high_sierra
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
