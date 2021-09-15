class Grpcurl < Formula
  desc "Like cURL, but for gRPC"
  homepage "https://github.com/fullstorydev/grpcurl"
  url "https://github.com/fullstorydev/grpcurl/archive/v1.8.2.tar.gz"
  sha256 "89e56bc6cdbf180068b02cc46078ebc3319010f2050f04247e1d535c7f9bf19b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "e3fcf482d0f653632affba8c27417fbc2c17c2416a650ac45f9f2f0035842e7c"
    sha256 cellar: :any_skip_relocation, big_sur:       "62679fca96b6f75564e48c357c5d5e73511c520fa5763513d959ef38c2543ca6"
    sha256 cellar: :any_skip_relocation, catalina:      "50d479387a7677bd8060c25b3c561b7364101e896977318ca6bd41143a937385"
    sha256 cellar: :any_skip_relocation, mojave:        "e6761ff587ae8a651991978f735a61ce5e4de4ed2e5e76329f7af1bb793908a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "56e47da19cea0ac48067934ce785c2f80c55d96afe27c910b3f314952b6b7290"
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
