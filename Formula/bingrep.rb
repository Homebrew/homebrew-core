class Bingrep < Formula
  desc "Greps through binaries from various OSs and architectures"
  homepage "https://github.com/m4b/bingrep"
  url "https://github.com/m4b/bingrep/archive/v0.10.3.tar.gz"
  sha256 "089c9c0fdc05971a10e7463629e6fa850bd681b83ad66745d0cb78041c4a81a8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f1adc1bf8f2d1649a3f96b07764097d2999f1f45161f83fe4da131b35feb6f3e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9facc7cf4350d43d0cdd146703aa0e6c32328ed238cb8123302e852e12031031"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "587c173f2d91a9962c4171a7e94c6500cf7b7862ce38747fed04c9df7091c7f4"
    sha256 cellar: :any_skip_relocation, monterey:       "247db0c2c60f8c0c8948e3b9713f8cd4581175c68b7814a2d49c6e5d6cc08e74"
    sha256 cellar: :any_skip_relocation, big_sur:        "6459f314ce15ed4d79439fd781a4ba87902896129c3fdaa5dfc6fb6213763beb"
    sha256 cellar: :any_skip_relocation, catalina:       "d409b61ad15fb9c5f63fa6765d497f870e83fdd2810a5fc1ed7eac8ff189b31b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f6334628344910dc05d429f44f222942205a6d5fa58b3e64574ae2aec7a6a223"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system bin/"bingrep", bin/"bingrep"
  end
end
