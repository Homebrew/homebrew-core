class ProtocGenGo < Formula
  desc "Go support for Google's protocol buffers"
  homepage "https://github.com/protocolbuffers/protobuf-go"
  url "https://github.com/protocolbuffers/protobuf-go/archive/refs/tags/v1.36.10.tar.gz"
  sha256 "41671a3121345fb6b9f98cf41609379ba379c0aaf86be9e862f87a1d69a40e89"
  license "BSD-3-Clause"
  head "https://github.com/protocolbuffers/protobuf-go.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "54a88571329f7a1cedfe1bb20d6e216ec8dcdc03302d1a800f879e0f02f3edf9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "54a88571329f7a1cedfe1bb20d6e216ec8dcdc03302d1a800f879e0f02f3edf9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "54a88571329f7a1cedfe1bb20d6e216ec8dcdc03302d1a800f879e0f02f3edf9"
    sha256 cellar: :any_skip_relocation, sonoma:        "6ad92eb7e2e6a5e91d5ebc21ca2a718e27e3671c25a5da5a31370fb42c5cbd12"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "078aa03a0d5c3fb93240afc99bbaa40074e806f30a276a251f23059cec11a7ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d68e135ce9be4aadd202bcb969accc48113d57e511d1d35f1565b5154735dfab"
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
    assert_path_exists testpath/"proto3.pb.go"
    refute_predicate (testpath/"proto3.pb.go").size, :zero?
  end
end
