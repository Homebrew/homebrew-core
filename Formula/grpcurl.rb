class Grpcurl < Formula
  desc "Like cURL, but for gRPC"
  homepage "https://github.com/fullstorydev/grpcurl"
  url "https://github.com/fullstorydev/grpcurl/archive/v1.8.1.tar.gz"
  sha256 "1dae107fdd32042f4fe5803378c5e0db124d573d4b96fc39cc32464b8d5adfbb"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "5551aeee38f48b7a3c31117d0c5c1791f1a71a62c96d0231dc8da712f95ad6f2"
    sha256 cellar: :any_skip_relocation, big_sur:       "be03266644292007336a1927e1a3c32c26132c10e6cdddf24f2be2db723616ad"
    sha256 cellar: :any_skip_relocation, catalina:      "cc7aa37de783837e837c441575df7f6b5ef169b83a5017b2b62fc1ce4c4c09c3"
    sha256 cellar: :any_skip_relocation, mojave:        "a4cf31d2358f4d8e36a695a2a9c401672cd7d80f0be54dda2d4d7fb62702b49c"
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
