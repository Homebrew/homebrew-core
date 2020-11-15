class ProtocGenGoGrpc < Formula
  desc "Protoc plugin that generates code for gRPC-Go clients"
  homepage "https://github.com/grpc/grpc-go"
  url "https://github.com/grpc/grpc-go/archive/cmd/protoc-gen-go-grpc/v1.0.1.tar.gz"
  sha256 "01bfd13d2140ff671fcb826d114d091f71b921102337ea730a9c21f8272fc655"
  license "Apache-2.0"
  revision 1

  livecheck do
    url :stable
    regex(%r{cmd/protoc-gen-go-grpc/v?(\d+(?:\.\d+)+)}i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "a49ad186b4d971288ad11c045dd3529db878ae5ae1bc61f5efd08aee3a2c557c" => :big_sur
    sha256 "012050e0d3a47290a2f8b55a8ec0c94898323d387a131b4021256f546d8e287a" => :catalina
    sha256 "d99636039e0f337539516bbcbb36b08bd600201588c3391d6619e04d3767e292" => :mojave
    sha256 "98f58a511df00b24d228148b8f938ddfdc1ef1968ebc0ec6dad57995ea7ac481" => :high_sierra
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
