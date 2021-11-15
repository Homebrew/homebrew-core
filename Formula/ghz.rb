class Ghz < Formula
  desc "Simple gRPC benchmarking and load testing tool"
  homepage "https://ghz.sh"
  url "https://github.com/bojand/ghz/archive/v0.105.0.tar.gz"
  sha256 "c2c257dcdf708e742ff80cd5a1b205991c9192cf857cafc90ed4be8ff2097ee1"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fdfbaf436fbab1e56fcc1bfa1db33f40a486146343a9a9f6f4cafa9bfde63bcb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c997364f2d9040d210dd3b1ba1c88b81c687e425e4fa2a576441016ae8ce8c13"
    sha256 cellar: :any_skip_relocation, monterey:       "69ebeccb409db9a850abd6a649266fab78611d33def0a68bec2baf9ea922901d"
    sha256 cellar: :any_skip_relocation, big_sur:        "539bbe9d9681221ecfb9e740b5495b587ba5c887297fb3f91c49c27fe53ce9e2"
    sha256 cellar: :any_skip_relocation, catalina:       "3ed01d5e3438b04d34b421a8cd3ddf7e8b40467c85b5e7a182a869a11832af77"
    sha256 cellar: :any_skip_relocation, mojave:         "bbe6cd3a20c9591857ee05d2e61fba97ef5dbbf83476d8b0c47687397ba8bb31"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bf02572c989e96394a223899c0156e8781474e7faa644a8dd5095d87882e5c41"
  end

  depends_on "go" => :build

  def install
    system "go", "build",
      "-ldflags", "-s -w -X main.version=#{version}",
      *std_go_args,
      "cmd/ghz/main.go"
    prefix.install_metafiles
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ghz -v 2>&1")
    (testpath/"config.toml").write <<~EOS
      proto = "greeter.proto"
      call = "helloworld.Greeter.SayHello"
      host = "0.0.0.0:50051"
      insecure = true
      [data]
      name = "Bob"
    EOS
    assert_match "open greeter.proto: no such file or directory",
      shell_output("#{bin}/ghz --config config.toml 2>&1", 1)
  end
end
