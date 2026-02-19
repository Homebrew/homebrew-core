class ProtocGenGoGrpc < Formula
  desc "Protoc plugin that generates code for gRPC-Go clients"
  homepage "https://github.com/grpc/grpc-go"
  url "https://github.com/grpc/grpc-go/archive/refs/tags/cmd/protoc-gen-go-grpc/v1.6.1.tar.gz"
  sha256 "9dae3e712ceda8f3740511632bdb18872387bc4642131d05d190e65483f4a422"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(%r{cmd/protoc-gen-go-grpc/v?(\d+(?:\.\d+)+)}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "23b5b2dfbc954af373166be4e13a6f559030114c931e0b35f16b75e0ac1636dc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "23b5b2dfbc954af373166be4e13a6f559030114c931e0b35f16b75e0ac1636dc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "23b5b2dfbc954af373166be4e13a6f559030114c931e0b35f16b75e0ac1636dc"
    sha256 cellar: :any_skip_relocation, sonoma:        "931fc918491c0b4dd87f68a731eea11765086b189dc0ad7099c8d092abaa0501"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1f27075ce0439369568899c03745d93c10c39b352117b8a31c6582d1a652d95d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "23f3e27aebf9cd43e9c97436554f7ef20d4869cb9c7d9cbd76f75328b3d90c42"
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
