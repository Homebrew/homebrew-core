class ProtocGenGo < Formula
  desc "Go support for Google's protocol buffers"
  homepage "https://github.com/protocolbuffers/protobuf-go"
  url "https://github.com/protocolbuffers/protobuf-go/archive/refs/tags/v1.34.2.tar.gz"
  sha256 "a91d3129e38945b612b7a377364dae324ed3a489c3a805a412805a0cee76e7a2"
  license "BSD-3-Clause"
  head "https://github.com/protocolbuffers/protobuf-go.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "74a1e9415b32c7f9884a7bbdbcb981c4a74d8b7511bb4a5e101c25f915cd0556"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "74a1e9415b32c7f9884a7bbdbcb981c4a74d8b7511bb4a5e101c25f915cd0556"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "74a1e9415b32c7f9884a7bbdbcb981c4a74d8b7511bb4a5e101c25f915cd0556"
    sha256 cellar: :any_skip_relocation, sonoma:         "60587bf8876bc3968ed3956b135ac37ec4a0c2a9e7e4bc1fa1b6f95fa006ab00"
    sha256 cellar: :any_skip_relocation, ventura:        "60587bf8876bc3968ed3956b135ac37ec4a0c2a9e7e4bc1fa1b6f95fa006ab00"
    sha256 cellar: :any_skip_relocation, monterey:       "60587bf8876bc3968ed3956b135ac37ec4a0c2a9e7e4bc1fa1b6f95fa006ab00"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "27dd3ac78a00efcdddb97774b73e972facf31c8edc773a9952d04ac0530db4f2"
  end

  depends_on "go" => :build
  depends_on "protobuf"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/protoc-gen-go"
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
