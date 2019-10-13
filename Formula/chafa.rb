class Chafa < Formula
  desc "Versatile and fast Unicode/ASCII/ANSI graphics renderer"
  homepage "https://hpjansson.org/chafa/"
  url "https://hpjansson.org/chafa/releases/chafa-1.0.1.tar.xz"
  sha256 "49d491a566a22daf56c51c043259f1373a1b1125d5c1c1fe321f7c25ca178e01"
  revision 1

  bottle do
    cellar :any
    sha256 "14410a807d87798ad31ebe34f2c4efe96e545b5d50b0c7d2991eda165d24ef8b" => :catalina
    sha256 "aaa7a1a6515a936e426de959cd5e12912f8ad8a4c496faa4f66e4a91ed8d3e20" => :mojave
    sha256 "0de874867a7fbb31bec2270bbb66ce09388287350a5ba047642ae0dfbfcd3b2e" => :high_sierra
    sha256 "b03b539cfcce1e802639c4ba5770ea63eaeff7bb8724b2eede19ba1edeb814c6" => :sierra
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
