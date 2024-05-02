class ProtocGenGo < Formula
  desc "Go support for Google's protocol buffers"
  homepage "https://github.com/protocolbuffers/protobuf-go"
  url "https://github.com/protocolbuffers/protobuf-go/archive/refs/tags/v1.34.0.tar.gz"
  sha256 "51e6e2a7c8d5e2d641433af3f6ba0316bc300246f79918502177e924b0953ae2"
  license "BSD-3-Clause"
  head "https://github.com/protocolbuffers/protobuf-go.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4454a7d86153113532a2d6b7a0768dbcd8466b5d275e0890485ef437152230e5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4454a7d86153113532a2d6b7a0768dbcd8466b5d275e0890485ef437152230e5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4454a7d86153113532a2d6b7a0768dbcd8466b5d275e0890485ef437152230e5"
    sha256 cellar: :any_skip_relocation, sonoma:         "43658e5738d25414202e42acc6eb3a18a832c03bc0e657893bd783b29237b139"
    sha256 cellar: :any_skip_relocation, ventura:        "43658e5738d25414202e42acc6eb3a18a832c03bc0e657893bd783b29237b139"
    sha256 cellar: :any_skip_relocation, monterey:       "43658e5738d25414202e42acc6eb3a18a832c03bc0e657893bd783b29237b139"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6aed1f0ab24115bd61f86a2a367acd606020b3d8f3297072e07db9a300ebca81"
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
