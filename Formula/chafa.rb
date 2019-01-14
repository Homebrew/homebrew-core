class Chafa < Formula
  desc "Versatile and fast Unicode/ASCII/ANSI graphics renderer"
  homepage "https://hpjansson.org/chafa/"
  url "https://hpjansson.org/chafa/releases/chafa-1.0.1.tar.xz"
  sha256 "49d491a566a22daf56c51c043259f1373a1b1125d5c1c1fe321f7c25ca178e01"

  bottle do
    cellar :any
    sha256 "21473001e0cad95603414f9cd242d408f37c3fd805f8283ba004becf2e5745be" => :mojave
    sha256 "12c49e4749823ad7e1acc8fbf4c7b8c30d59a7beceb10af83b909ed3848712db" => :high_sierra
    sha256 "1eafdaf63d64ef0e1a86f4c86f101efcc078cd270b3a10b47934617ac1bd625f" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "imagemagick"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    output = shell_output("#{bin}/chafa #{test_fixtures("test.png")}")
    assert_equal 4, output.lines.count
  end
end
