class ProtocGenGo < Formula
  desc "Go support for Google's protocol buffers"
  homepage "https://github.com/protocolbuffers/protobuf-go"
  url "https://github.com/protocolbuffers/protobuf-go/archive/refs/tags/v1.36.6.tar.gz"
  sha256 "afa2b0e8f86d6da9d09c51ab4270d93c2888327220316982be9db345f523a6a1"
  license "BSD-3-Clause"
  head "https://github.com/protocolbuffers/protobuf-go.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "24ad37f1f73d1474cfa3a1b6218b9800b4216f5ba530dcb842328474c2797524"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "24ad37f1f73d1474cfa3a1b6218b9800b4216f5ba530dcb842328474c2797524"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "24ad37f1f73d1474cfa3a1b6218b9800b4216f5ba530dcb842328474c2797524"
    sha256 cellar: :any_skip_relocation, sonoma:        "27d05a9fb2bd374860fe55eef13ec0c0f42ec4341719e69b0eced035c04e494b"
    sha256 cellar: :any_skip_relocation, ventura:       "27d05a9fb2bd374860fe55eef13ec0c0f42ec4341719e69b0eced035c04e494b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d5fb6bfcb3e2cf28ab4e97c2f41d215dac135638eaf4be1836ccceadff88adea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4be3e922fc3702067fda53a06bcad228ed713198afcda82079e6611e05cbea64"
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
