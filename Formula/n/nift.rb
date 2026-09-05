class Nift < Formula
  desc "Fast dependency-aware website generator"
  homepage "https://nift.dev/"
  url "https://github.com/nift-dev/nift/archive/refs/tags/v4.0.9.tar.gz"
  sha256 "31f4ea3ba16649034e337ce00729b32752330253968dfe01418cf74e13d14b6d"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "47b8848a9df3f42bb010416a0cc2c6de36b14575e23919f3bdc1a15542990a89"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9076ed11a7cc11c70fb6908071ec93f1f1b07f9601d29858f74f589c1e92343c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "efb0eab9fb0c2b913968d2efeb57aff6fa8b2d07d8beae5125a3b9c8ecb511ea"
    sha256 cellar: :any,                 arm64_linux:   "fba6956c16e12cc5f1e20983c162b0b791ce6019fdfe9bca367aaa8746e8c5b2"
    sha256 cellar: :any,                 x86_64_linux:  "26238457d82cf667e8d28f66248f362964a119400121be9dee5b63d174eed7ca"
  end

  def install
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system bin/"nift", "init", "--ext=.html"
    assert_path_exists testpath/"public/index.html"
  end
end
