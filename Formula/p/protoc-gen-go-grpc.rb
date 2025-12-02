class ProtocGenGoGrpc < Formula
  desc "Protoc plugin that generates code for gRPC-Go clients"
  homepage "https://github.com/grpc/grpc-go"
  url "https://github.com/grpc/grpc-go/archive/refs/tags/cmd/protoc-gen-go-grpc/v1.6.0.tar.gz"
  sha256 "6e269733f8728b6583ce7e8ca4b2aafec286f4ac4e878a8d75477787ba8c389b"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(%r{cmd/protoc-gen-go-grpc/v?(\d+(?:\.\d+)+)}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "74fa938b6c413d2f9cf4256ea0d685f4d3dea7eee6b9ce2b93feed4a64816947"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "74fa938b6c413d2f9cf4256ea0d685f4d3dea7eee6b9ce2b93feed4a64816947"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "74fa938b6c413d2f9cf4256ea0d685f4d3dea7eee6b9ce2b93feed4a64816947"
    sha256 cellar: :any_skip_relocation, sonoma:        "23de8b8068e2f2764edae843d0a094d9ea132416079ffb0c79e633f3db0c4df0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "63dfad81a3f328efa3b88f140bfc7f7ca42f85844fe0b3feae3a498f43306b7c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7758f6d4ef38b79278f86f46fe799326332090619f1bc6a838ccf17cbce8f7d7"
  end

  depends_on "go" => :build
  depends_on "protobuf"

  def install
    cd "cmd/protoc-gen-go-grpc" do
      system "go", "build", *std_go_args(ldflags: "-s -w")
    end
  end

  test do
    (testpath/"service.proto").write <<~PROTO
      syntax = "proto3";

      option go_package = ".;proto";

      service Greeter {
        rpc Hello(HelloRequest) returns (HelloResponse);
      }

      message HelloRequest {}
      message HelloResponse {}
    PROTO

    system "protoc", "--plugin=#{bin}/protoc-gen-go-grpc", "--go-grpc_out=.", "service.proto"

    assert_path_exists testpath/"service_grpc.pb.go"
  end
end
