class Grpcurl < Formula
  desc "Like cURL, but for gRPC"
  homepage "https://github.com/fullstorydev/grpcurl"
  url "https://github.com/fullstorydev/grpcurl/archive/v1.8.7.tar.gz"
  sha256 "7f7a59f8a5ef8833d30a94e1c36ddb0d76bab1ae64cd5c8bcb87d42e877c3bca"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "12c372c78ff682370a954b7e8f6faa2a432e6b1b9eb4f5adcd5942a687095aa6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "37d01a36b9911c64b6a32ee44d1ed9eb148fb1844df0b81c1b19c235ed7fd907"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "81421aa8f13a8d6993aa60172b0252ac503daec9980441af6ee025af58eb8acb"
    sha256 cellar: :any_skip_relocation, ventura:        "bd1f6f8ee21b8ba12d83d7211e8006ca873c5f3a692c36f573be8c5202552c0f"
    sha256 cellar: :any_skip_relocation, monterey:       "7f7e652c6277205d1ae756475b283fa750eaf7aa3325be9ea08ba33f4939a040"
    sha256 cellar: :any_skip_relocation, big_sur:        "12f6441cce946edee12c07729ab0e9b433dc44094b57dabd3e4e6e1864b4a811"
    sha256 cellar: :any_skip_relocation, catalina:       "6bb6275586993be3b1b9f9db7ad86a91d12e733815d7cb89141dca02b0b1ba54"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a2ff19dc12a0e3df9384e6431a8f8f35e8ecd9527694a837f9a750121c58778b"
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
