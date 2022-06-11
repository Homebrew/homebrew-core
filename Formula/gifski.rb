class Gifski < Formula
  desc "Highest-quality GIF encoder based on pngquant"
  homepage "https://gif.ski/"
  url "https://github.com/ImageOptim/gifski/archive/1.7.0.tar.gz"
  sha256 "f9d66778d763f2391fa626261d24815799f1dfe61ce9ee0cc5637692172db29d"
  license "AGPL-3.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "59840cc6d34510cbde228cedbae08d270effbd2c427748cb98b0685154effb55"
    sha256 cellar: :any,                 arm64_big_sur:  "06a4710d0902483c75377e7fffadb47cf28577ad32c2c6ac6cbb398ae07fc972"
    sha256 cellar: :any,                 monterey:       "6995c7396bf11196d20f76b55d50aa1680942de8f05ac20da05fad1aa4f933d2"
    sha256 cellar: :any,                 big_sur:        "4060dcb4e64572d843ebdb8c6cdeeef011fb7e586844c61fb11b0ca70bd02239"
    sha256 cellar: :any,                 catalina:       "e3e324b67bee1677e69d327669082a7a2bb4593e5a3aa6f3d76fc6a1d41f1f36"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ad6ec536a7c531cc186390da8b099148d0fc01119f25408c72fa245e31821daf"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "ffmpeg@4"

  uses_from_macos "llvm" => :build

  on_linux do
    depends_on "gcc"
  end

  fails_with gcc: "5" # rubberband is built with GCC

  def install
    system "cargo", "install", "--features", "video", *std_cargo_args
  end

  test do
    png = test_fixtures("test.png")
    system bin/"gifski", "-o", "out.gif", png, png
    assert_predicate testpath/"out.gif", :exist?
    refute_predicate (testpath/"out.gif").size, :zero?
  end
end
