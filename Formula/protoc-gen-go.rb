class ProtocGenGo < Formula
  desc "Go support for Google's protocol buffers"
  homepage "https://github.com/protocolbuffers/protobuf-go"
  url "https://github.com/protocolbuffers/protobuf-go/archive/v1.27.1.tar.gz"
  sha256 "3ec41a8324431e72f85e0dc0c2c098cc14c3cb1ee8820996c8f46afca2d65609"
  license "BSD-3-Clause"
  head "https://github.com/protocolbuffers/protobuf-go.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "66a055296f1284d23b625e3864c55df6389c8aff6315de3021ae538ec4d9cc1e"
    sha256 cellar: :any_skip_relocation, big_sur:       "db8d23c9a2a2e42898968dcaab47ba2700ec17125a889aa064dd7c74014502ac"
    sha256 cellar: :any_skip_relocation, catalina:      "db8d23c9a2a2e42898968dcaab47ba2700ec17125a889aa064dd7c74014502ac"
    sha256 cellar: :any_skip_relocation, mojave:        "db8d23c9a2a2e42898968dcaab47ba2700ec17125a889aa064dd7c74014502ac"
  end

  depends_on "go" => :build
  depends_on "protobuf"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/protoc-gen-go"
    prefix.install_metafiles
  end

  test do
    protofile = testpath/"proto3.proto"
    protofile.write <<~EOS
      syntax = "proto3";
      package proto3;
      option go_package = "package/test";
      message Request {
        string name = 1;
        repeated int64 key = 2;
      }
    EOS
    system "protoc", "--go_out=.", "--go_opt=paths=source_relative", "proto3.proto"
    assert_predicate testpath/"proto3.pb.go", :exist?
    refute_predicate (testpath/"proto3.pb.go").size, :zero?
  end
end
