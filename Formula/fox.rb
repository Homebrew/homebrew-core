class Fox < Formula
  desc "Toolkit for developing Graphical User Interfaces easily"
  homepage "http://www.fox-toolkit.org/"
  url "http://fox-toolkit.org/ftp/fox-1.6.55.tar.gz"
  sha256 "172416625221e54dcc1c4293fc892b9695f1e952f4b895376e6604c6c3813d74"

  bottle do
    cellar :any
    sha256 "ece7adf2fe555c4a8872ce8581d98562a030498010133de035315d366dd7459d" => :high_sierra
    sha256 "93c94db6535ede86fd5ae0a7998d3dd231ff8d3a5747a1b73bdc1212ca467ec5" => :sierra
    sha256 "2ca2e3c75121d687d575656ef82ddcd45c6cc63d9f79151679e34b0d42b93733" => :el_capitan
  end

  depends_on :x11
  depends_on "freetype"
  depends_on "libpng"
  depends_on "jpeg"
  depends_on "libtiff"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--enable-release",
                          "--prefix=#{prefix}",
                          "--with-x",
                          "--with-opengl"
    # Unset LDFLAGS, "-s" causes the linker to crash
    system "make", "install", "LDFLAGS="
    rm bin/"Adie.stx"
  end

  test do
    system bin/"reswrap", "-t", "-o", "text.txt", test_fixtures("test.jpg")
    assert_match "\\x00\\x85\\x80\\x0f\\xae\\x03\\xff\\xd9", File.read("text.txt")
  end
end
