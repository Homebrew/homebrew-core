class ProtocGenGoGrpc < Formula
  desc "Protoc plugin that generates code for gRPC-Go clients"
  homepage "https://github.com/grpc/grpc-go"
  url "https://github.com/grpc/grpc-go/archive/cmd/protoc-gen-go-grpc/v1.2.0.tar.gz"
  sha256 "cbca93d6dce724248dfdea6303bf27ed24cc3ed9cf8f7485eb825682eab21284"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(%r{cmd/protoc-gen-go-grpc/v?(\d+(?:\.\d+)+)}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4b312550d444e21364492c1ff057b43c3ecc6bae4ada717f279f61ffb5f71503"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cd352d68303c62b39a576046b4a68684b9fcf2785a4cf7fb7da623366a5c0c9c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cd352d68303c62b39a576046b4a68684b9fcf2785a4cf7fb7da623366a5c0c9c"
    sha256 cellar: :any_skip_relocation, ventura:        "1533c1cc3cd0e193e630ac450922793f7a4b4bb6dfae8817a1c52de1f388e690"
    sha256 cellar: :any_skip_relocation, monterey:       "750b1205aabb9ff53f834fdb0927fe001e7a96c7a069ada4a78d5cef92103e45"
    sha256 cellar: :any_skip_relocation, big_sur:        "750b1205aabb9ff53f834fdb0927fe001e7a96c7a069ada4a78d5cef92103e45"
    sha256 cellar: :any_skip_relocation, catalina:       "750b1205aabb9ff53f834fdb0927fe001e7a96c7a069ada4a78d5cef92103e45"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5c83e40e7f5813fbe2b7e8468394e423f0ca814c219d70c73054f48ac4f642d4"
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
