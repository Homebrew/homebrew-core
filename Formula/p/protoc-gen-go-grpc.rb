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
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "1ad7618388f5992c35a75815b0de19f40518aff8743c448007277c5e735a52cc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7e92a04eb0c88228fff5b5e9088d9e1b278214418a59ebcd35bf721a54ad7e98"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7e92a04eb0c88228fff5b5e9088d9e1b278214418a59ebcd35bf721a54ad7e98"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7e92a04eb0c88228fff5b5e9088d9e1b278214418a59ebcd35bf721a54ad7e98"
    sha256 cellar: :any_skip_relocation, sonoma:         "916c049867e8311c96322dba2c05a976fac1104d842114cebfe6cfb42f63db8a"
    sha256 cellar: :any_skip_relocation, ventura:        "916c049867e8311c96322dba2c05a976fac1104d842114cebfe6cfb42f63db8a"
    sha256 cellar: :any_skip_relocation, monterey:       "916c049867e8311c96322dba2c05a976fac1104d842114cebfe6cfb42f63db8a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a6252fdd5f14faaa8467cd9f5ce529b22c22aa2b8b4625ade71b52e28a2a2cb1"
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
