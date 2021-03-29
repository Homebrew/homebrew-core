class ProtocGenGo < Formula
  desc "Go support for Google's protocol buffers"
  homepage "https://github.com/golang/protobuf"
  url "https://github.com/golang/protobuf/archive/v1.5.2.tar.gz"
  sha256 "088cc0f3ba18fb8f9d00319568ff0af5a06d8925a6e6cb983bb837b4efb703b3"
  license "BSD-3-Clause"
  head "https://github.com/golang/protobuf.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "ccdf8bdcba2e1fda82663ddd65757b6a97369965af903e2d73d52ca8af481c7d"
    sha256 cellar: :any_skip_relocation, big_sur:       "5ad7555788800ed282712de3d1b2546fca56b75cc4322cfd70558f933797489e"
    sha256 cellar: :any_skip_relocation, catalina:      "0a15603b6ac4a957f82a807e8cd0a828685ae7907d21587ecc0146c44b233ec4"
    sha256 cellar: :any_skip_relocation, mojave:        "648ad38adc976cf325d78dde60483119c1b2df1efb8ad9e27afd69335a09a2dc"
  end

  depends_on "go" => :build
  depends_on "protobuf"

  def install
    system "go", "build", *std_go_args, "-ldflags", "-s -w", "./protoc-gen-go"
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
