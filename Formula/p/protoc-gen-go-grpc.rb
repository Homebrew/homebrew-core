class ProtocGenGoGrpc < Formula
  desc "Protoc plugin that generates code for gRPC-Go clients"
  homepage "https://github.com/grpc/grpc-go"
  url "https://github.com/grpc/grpc-go/archive/refs/tags/cmd/protoc-gen-go-grpc/v1.5.1.tar.gz"
  sha256 "54cb438abe590c9366e08251f811810fa004b1193154fe6e6a7d7c782a37332e"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(%r{cmd/protoc-gen-go-grpc/v?(\d+(?:\.\d+)+)}i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6fea4b83597ec851d649c1b749618dda37e3815b4780b28467557aa0a29df606"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6fea4b83597ec851d649c1b749618dda37e3815b4780b28467557aa0a29df606"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6fea4b83597ec851d649c1b749618dda37e3815b4780b28467557aa0a29df606"
    sha256 cellar: :any_skip_relocation, sonoma:        "5f99bc500ba51adf40e538a0400b8f345647cc0e7b0275745aa1f195e87910a3"
    sha256 cellar: :any_skip_relocation, ventura:       "5f99bc500ba51adf40e538a0400b8f345647cc0e7b0275745aa1f195e87910a3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "62026292030029c59eae929f0bf18641e9fd74e88a1b4ec68450c7b7bf4bd61a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b754fb14b20c7f4fe1f9f3f03693b2100ea882ffb3fad7c40f96df092437f870"
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
