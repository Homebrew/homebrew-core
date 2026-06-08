class ProtocGenGoGrpc < Formula
  desc "Protoc plugin that generates code for gRPC-Go clients"
  homepage "https://github.com/grpc/grpc-go"
  url "https://github.com/grpc/grpc-go/archive/refs/tags/cmd/protoc-gen-go-grpc/v1.6.2.tar.gz"
  sha256 "a5f284c76292c8f4460aa57d0dfe81ee44f4670082a575f43324523ec6ef15e7"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(%r{cmd/protoc-gen-go-grpc/v?(\d+(?:\.\d+)+)}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "613a0784608b460910965dff2dbe76c7019ca21366711fdf2f0c72d87d1627ec"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "613a0784608b460910965dff2dbe76c7019ca21366711fdf2f0c72d87d1627ec"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "613a0784608b460910965dff2dbe76c7019ca21366711fdf2f0c72d87d1627ec"
    sha256 cellar: :any_skip_relocation, sonoma:        "3bbc54aa67f384df93ad4690dc4baccd2253e4a4f3839bee6630e2a36fa7ae39"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "245f6da79af4e7a0e13f6a8730a7f3975afb0a400a222ce14d239ac29fadf556"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3766731846ba260cfb5936178814889fcf50644a714645cfa0bad8cabb4b0512"
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
