class Grpcurl < Formula
  desc "Like cURL, but for gRPC"
  homepage "https://github.com/fullstorydev/grpcurl"
  url "https://github.com/fullstorydev/grpcurl/archive/v1.8.8.tar.gz"
  sha256 "b36990189922ee3ac07e91be83e6dafcb5e6fcfc0039378d42a1c76c87a7cbd8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "73aa020887bbfd505d1d9cd74fb30d83f696b00dbbff462ce186f18e02017b2d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c483a82109e8e90c88df75803ecd52aa816850085d7d87cad01fc88cac011538"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "33423e62a521007067f8a0cdd2ba3f6047dc5e77c251b3c90036911359b90e35"
    sha256 cellar: :any_skip_relocation, ventura:        "d07c310be5bdfd492647f696c7dd4f8816054c2d5f1bb90f185702be031d1b59"
    sha256 cellar: :any_skip_relocation, monterey:       "e279d0a8384f3cc69b8b9605472e5d53e332181aab280ded64d722754b1eb0c4"
    sha256 cellar: :any_skip_relocation, big_sur:        "6c09776cc6061c824cbe167adc3099ee3a6df1991d495f5c2060cc9ee1da47f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4ef38454054085afabced3c11c7c91bcbf7b391c7330c78d374087eb9d6fc3bc"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}"), "./cmd/grpcurl"
  end

  test do
    (testpath/"test.proto").write <<~EOS
      syntax = "proto3";
      package test;
      message HelloWorld {
        string hello_world = 1;
      }
    EOS
    system "#{bin}/grpcurl", "-msg-template", "-proto", "test.proto", "describe", "test.HelloWorld"
  end
end
