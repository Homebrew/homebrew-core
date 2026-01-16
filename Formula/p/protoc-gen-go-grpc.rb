class ProtocGenGoGrpc < Formula
  desc "Protoc plugin that generates code for gRPC-Go clients"
  homepage "https://github.com/grpc/grpc-go"
  url "https://github.com/grpc/grpc-go/archive/refs/tags/cmd/protoc-gen-go-grpc/v1.6.0.tar.gz"
  sha256 "6e269733f8728b6583ce7e8ca4b2aafec286f4ac4e878a8d75477787ba8c389b"
  license "Apache-2.0"
  revision 1

  livecheck do
    url :stable
    regex(%r{cmd/protoc-gen-go-grpc/v?(\d+(?:\.\d+)+)}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8f1b7364fb58f3114af0cb279f95bfd8ca75c5668370ab660985f3d664ff4c6b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8f1b7364fb58f3114af0cb279f95bfd8ca75c5668370ab660985f3d664ff4c6b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8f1b7364fb58f3114af0cb279f95bfd8ca75c5668370ab660985f3d664ff4c6b"
    sha256 cellar: :any_skip_relocation, sonoma:        "dae87a508c5b65366ee6040bef6c92db9cd01ae74a312758e6e763d76201c5ad"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0893c49d9b70f3eaacae8d7d8dc995a67cf7a507c9994124b80e5b1649f7acb2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2713b5516337288a481945fb9979c800b46d9b04f824d936ad74dfb928895d13"
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
