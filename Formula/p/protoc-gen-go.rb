class ProtocGenGo < Formula
  desc "Go support for Google's protocol buffers"
  homepage "https://github.com/protocolbuffers/protobuf-go"
  url "https://github.com/protocolbuffers/protobuf-go/archive/refs/tags/v1.36.3.tar.gz"
  sha256 "d15b5c42786fa47d716b1572e5ba21979dc3163121854ece5101f072d4fa95bb"
  license "BSD-3-Clause"
  head "https://github.com/protocolbuffers/protobuf-go.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f51d5cabe181f241f4b5415a1baa0db83680470f659c2307dfb75aaec27d2d07"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f51d5cabe181f241f4b5415a1baa0db83680470f659c2307dfb75aaec27d2d07"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f51d5cabe181f241f4b5415a1baa0db83680470f659c2307dfb75aaec27d2d07"
    sha256 cellar: :any_skip_relocation, sonoma:        "a726717c196983423df9078c4a5c50bdf41f3ec13f37ac46e64234ac22172d8a"
    sha256 cellar: :any_skip_relocation, ventura:       "a726717c196983423df9078c4a5c50bdf41f3ec13f37ac46e64234ac22172d8a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8d8b06c1e8070f9795af7c55c8a4b0ab6858f1fb9fdb25f108eaf1ec6d442aa2"
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
