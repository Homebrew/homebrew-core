class ProtocGenGo < Formula
  desc "Go support for Google's protocol buffers"
  homepage "https://github.com/protocolbuffers/protobuf-go"
  url "https://github.com/protocolbuffers/protobuf-go/archive/v1.31.0.tar.gz"
  sha256 "96d670e9bae145ff2dd0f48a3693edb1f45ec3ee56d5f50a5f01cc7e060314bc"
  license "BSD-3-Clause"
  head "https://github.com/protocolbuffers/protobuf-go.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "939634a0da53aca0a0315c5318b5569c13618b08bb3273734fca3aa92b0b26b1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "939634a0da53aca0a0315c5318b5569c13618b08bb3273734fca3aa92b0b26b1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "939634a0da53aca0a0315c5318b5569c13618b08bb3273734fca3aa92b0b26b1"
    sha256 cellar: :any_skip_relocation, ventura:        "1afc1f2ba6cf7328366c1c1b3246c02c6d6cbcd4ed07dc23d59453938b3d3ced"
    sha256 cellar: :any_skip_relocation, monterey:       "1afc1f2ba6cf7328366c1c1b3246c02c6d6cbcd4ed07dc23d59453938b3d3ced"
    sha256 cellar: :any_skip_relocation, big_sur:        "1afc1f2ba6cf7328366c1c1b3246c02c6d6cbcd4ed07dc23d59453938b3d3ced"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4a949330466de2f48fee364ced56c66b7dba830b3310b90064780a07e8109ee5"
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
