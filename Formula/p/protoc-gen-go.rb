class ProtocGenGo < Formula
  desc "Go support for Google's protocol buffers"
  homepage "https://github.com/protocolbuffers/protobuf-go"
  url "https://github.com/protocolbuffers/protobuf-go/archive/refs/tags/v1.36.4.tar.gz"
  sha256 "aba12e3abb045d9fc995aad578f0c0ab569325bedc277ffc9b5d159ccc78bbc5"
  license "BSD-3-Clause"
  head "https://github.com/protocolbuffers/protobuf-go.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3c83b8b6e741d26ee66c66b1eea60e96ce85d3a643ded056edfdbdc29e88f801"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3c83b8b6e741d26ee66c66b1eea60e96ce85d3a643ded056edfdbdc29e88f801"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3c83b8b6e741d26ee66c66b1eea60e96ce85d3a643ded056edfdbdc29e88f801"
    sha256 cellar: :any_skip_relocation, sonoma:        "175480e1e54f1a69c7f51c53b3d1120c2fc8efaaea67564a6ca5fbbaea553dec"
    sha256 cellar: :any_skip_relocation, ventura:       "175480e1e54f1a69c7f51c53b3d1120c2fc8efaaea67564a6ca5fbbaea553dec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f5dd73abeb631323d673f29584a0c52e2352c0870fd702ca8d7072ef67109d46"
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
