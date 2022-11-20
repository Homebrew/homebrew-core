class Gifski < Formula
  desc "Highest-quality GIF encoder based on pngquant"
  homepage "https://gif.ski/"
  url "https://github.com/ImageOptim/gifski/archive/1.8.0.tar.gz"
  sha256 "77bbb6736217f0fe43e2c2b49855fe22e32d41f77b5e715950b7a52903518f9c"
  license "AGPL-3.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "27a7e091fbdcd34ba75a02652b4156b464b64486694a58e8f03ba1ea6a944fae"
    sha256 cellar: :any,                 arm64_monterey: "96ea9a1468317ad1783bcfa18aa2ca719d1607cd291b730fafff0fa0e30ead0c"
    sha256 cellar: :any,                 arm64_big_sur:  "94704c28e4583532f0417276b1363d6b1ff8d9f1bd3735712968459cd18137e7"
    sha256 cellar: :any,                 ventura:        "636fbf1a0cff25242cdc41fa48e89616813103e4ed37dde08c98d51257196e39"
    sha256 cellar: :any,                 monterey:       "be3e6bdf0fbe9093e50f0c6d1f7b893c50dee885694ef9331c09677b8abdeab5"
    sha256 cellar: :any,                 big_sur:        "d2f2efbb61e951b0fc24c419a5c329ed076e80080e383673bd43bb1b34390bef"
    sha256 cellar: :any,                 catalina:       "e9fcf261f21ac2bcff8682f533191e807db14fb98e252126b3577231d353f724"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6be427f46718adafae0f1a2add356d42fe705a240e75745c86efe7113fa11fb3"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "ffmpeg@4"

  uses_from_macos "llvm" => :build

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
