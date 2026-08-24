class ProtocGenGo < Formula
  desc "Go support for Google's protocol buffers"
  homepage "https://github.com/protocolbuffers/protobuf-go"
  url "https://github.com/protocolbuffers/protobuf-go/archive/refs/tags/v1.36.12.tar.gz"
  sha256 "23a247d69c52872ecbfd6bcbee3216793b2672fa5a7b99497777bf9c3563756f"
  license "BSD-3-Clause"
  head "https://github.com/protocolbuffers/protobuf-go.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1d3ea7f6966d72d75289a2a65be6afaf14ff71a8061ae323b9533519ea95dc47"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1d3ea7f6966d72d75289a2a65be6afaf14ff71a8061ae323b9533519ea95dc47"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1d3ea7f6966d72d75289a2a65be6afaf14ff71a8061ae323b9533519ea95dc47"
    sha256 cellar: :any_skip_relocation, sonoma:        "0ff0aefc9da584d321fcb514ff467f5217dc9fe48cd161806acbc29f6ec59923"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "78c56311cb7a4e33ab06f030341dc242e58af64d99f94ccd766748abb6e497ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9da9a84d24bd16f9122e25769a65e4fa6b6c7e415d618b65af5923fda9c2453a"
  end

  depends_on "go" => :build
  depends_on "protobuf" => :no_linkage

  def install
    system "go", "build", *std_go_args, "./cmd/protoc-gen-go"
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
