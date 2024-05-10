class ProtocGenGo < Formula
  desc "Go support for Google's protocol buffers"
  homepage "https://github.com/protocolbuffers/protobuf-go"
  url "https://github.com/protocolbuffers/protobuf-go/archive/refs/tags/v1.34.1.tar.gz"
  sha256 "8aff9ec0c28a926daeedb1ce1f87a284e22fc5a892e9e5f7c850881137c85000"
  license "BSD-3-Clause"
  head "https://github.com/protocolbuffers/protobuf-go.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "40fe99df11a1a8e472f25f172794e902ff4a29c511edef96d9106e0119c0c6ba"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "40fe99df11a1a8e472f25f172794e902ff4a29c511edef96d9106e0119c0c6ba"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "40fe99df11a1a8e472f25f172794e902ff4a29c511edef96d9106e0119c0c6ba"
    sha256 cellar: :any_skip_relocation, sonoma:         "6559db4561f5ebde6f88ff7822c802a4a0bad4e92668c58baf6f16143b6371e2"
    sha256 cellar: :any_skip_relocation, ventura:        "6559db4561f5ebde6f88ff7822c802a4a0bad4e92668c58baf6f16143b6371e2"
    sha256 cellar: :any_skip_relocation, monterey:       "6559db4561f5ebde6f88ff7822c802a4a0bad4e92668c58baf6f16143b6371e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f66bcdeabcb6b097dfeba54088c1f958a6c1fd36812fc63abe42286d816edc9e"
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
