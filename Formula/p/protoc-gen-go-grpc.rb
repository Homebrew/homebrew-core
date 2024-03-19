class ProtocGenGoGrpc < Formula
  desc "Protoc plugin that generates code for gRPC-Go clients"
  homepage "https://github.com/grpc/grpc-go"
  url "https://github.com/grpc/grpc-go/archive/refs/tags/cmd/protoc-gen-go-grpc/v1.3.0.tar.gz"
  sha256 "26ea2bdea1aeba2180046544d468012ce9cb07667ac1f19476febb13ecc781f9"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(%r{cmd/protoc-gen-go-grpc/v?(\d+(?:\.\d+)+)}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8848163ae66b1de08ed10476110680709e6a36d19107145791c9ad3f0225a798"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2ce6de96edd28fb7ec125d97c998b9a32bb6c35a0451071206e5c16c1bc504ea"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2ce6de96edd28fb7ec125d97c998b9a32bb6c35a0451071206e5c16c1bc504ea"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2ce6de96edd28fb7ec125d97c998b9a32bb6c35a0451071206e5c16c1bc504ea"
    sha256 cellar: :any_skip_relocation, sonoma:         "62a0e8a0ac57a5d2eb228fdb0cdb305baf841a077664187cad932593cc5e1190"
    sha256 cellar: :any_skip_relocation, ventura:        "3187063cd6188fcae246605c563f6c70310fdd696947bbad0b1e3fd82dc718cf"
    sha256 cellar: :any_skip_relocation, monterey:       "3187063cd6188fcae246605c563f6c70310fdd696947bbad0b1e3fd82dc718cf"
    sha256 cellar: :any_skip_relocation, big_sur:        "3187063cd6188fcae246605c563f6c70310fdd696947bbad0b1e3fd82dc718cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "10efd80ac16fb47a8554a039258c4876013b54a1ebd19008eff8b2d9c87a0e19"
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
