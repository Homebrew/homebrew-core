class Grpcurl < Formula
  desc "Like cURL, but for gRPC"
  homepage "https://github.com/fullstorydev/grpcurl"
  url "https://github.com/fullstorydev/grpcurl/archive/refs/tags/v1.9.2.tar.gz"
  sha256 "9259935b6ef86d701caef60be338600798348368c0f4dca063a45cf88d8186a8"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "18b1180ca2627a4fd5f3da775a9095d3349c14b1c030bce929faddfed56e7e02"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "18b1180ca2627a4fd5f3da775a9095d3349c14b1c030bce929faddfed56e7e02"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "18b1180ca2627a4fd5f3da775a9095d3349c14b1c030bce929faddfed56e7e02"
    sha256 cellar: :any_skip_relocation, sonoma:        "5202cec41fc1afc38feb1357e896ed8287454b414a556a3d2efc98bbce229848"
    sha256 cellar: :any_skip_relocation, ventura:       "5202cec41fc1afc38feb1357e896ed8287454b414a556a3d2efc98bbce229848"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1b4a1cef08d364c3a0f0f2692820901146493aeb4aaf8bb47ff7e6dd035e7ad6"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), "./cmd/grpcurl"
  end

  test do
    (testpath/"test.proto").write <<~PROTO
      syntax = "proto3";
      package test;
      message HelloWorld {
        string hello_world = 1;
      }
    PROTO
    system bin/"grpcurl", "-msg-template", "-proto", "test.proto", "describe", "test.HelloWorld"
  end
end
