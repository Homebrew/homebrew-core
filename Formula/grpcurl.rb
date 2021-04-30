class Grpcurl < Formula
  desc "Like cURL, but for gRPC"
  homepage "https://github.com/fullstorydev/grpcurl"
  url "https://github.com/fullstorydev/grpcurl/archive/v1.8.1.tar.gz"
  sha256 "1dae107fdd32042f4fe5803378c5e0db124d573d4b96fc39cc32464b8d5adfbb"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "6fff430f23353c620fec2bf5994759846139337f1aaf379cf3520eff089e0b35"
    sha256 cellar: :any_skip_relocation, big_sur:       "ce5d605bad57e29e0cfdb0c7abacf7557c37709487da1568b3b61c6ae78dac5e"
    sha256 cellar: :any_skip_relocation, catalina:      "ffe4d86a9401a8f8967400709fcda90c88a7bff84d90b429639ef3674920097d"
    sha256 cellar: :any_skip_relocation, mojave:        "b1d296a3c4a2a3eb668cb84330473cf30d2960929d5af7578c8e2716d600c538"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "-ldflags", "-X main.version=#{version}", "./cmd/grpcurl"
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
