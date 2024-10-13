class ProtocGenGo < Formula
  desc "Go support for Google's protocol buffers"
  homepage "https://github.com/protocolbuffers/protobuf-go"
  url "https://github.com/protocolbuffers/protobuf-go/archive/refs/tags/v1.35.1.tar.gz"
  sha256 "7cead1a711d682796b343931a9b54b3b07dd83456baeda6c069432235de45437"
  license "BSD-3-Clause"
  head "https://github.com/protocolbuffers/protobuf-go.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d9c727b235e45e08019c4fb191b34fc1c65588c56c7f364dfb7a320e37da8099"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d9c727b235e45e08019c4fb191b34fc1c65588c56c7f364dfb7a320e37da8099"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d9c727b235e45e08019c4fb191b34fc1c65588c56c7f364dfb7a320e37da8099"
    sha256 cellar: :any_skip_relocation, sonoma:        "537e33a1908fa39b19ea31ce0206f67216beec09981a6d346005c1746e50ed7b"
    sha256 cellar: :any_skip_relocation, ventura:       "537e33a1908fa39b19ea31ce0206f67216beec09981a6d346005c1746e50ed7b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ecbb4a561e7a582aa91314657f165493a297cae55ccb2c7c5ba89357b3b90af9"
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
