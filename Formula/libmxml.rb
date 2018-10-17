class Libmxml < Formula
  desc "Mini-XML library"
  homepage "https://michaelrsweet.github.io/mxml/"
  url "https://github.com/michaelrsweet/mxml/releases/download/v2.12/mxml-2.12.tar.gz"
  sha256 "afd6b75a120dc422c7b45dca19254f535d51c37b73f6783962b1e14b54c716fd"
  head "https://github.com/michaelrsweet/mxml.git"

  bottle do
    cellar :any
    sha256 "3ab68ae639d1b5f78b756d689c66303a0e1f2d2bb34a417ce374d01fb6a5b176" => :high_sierra
    sha256 "03b417fb39a0293c2dad5fe18ddf36e7692e93cd35338d32013394cc6f1d34a7" => :sierra
    sha256 "f33aab3398c00853fad6045acef1184c16fa6fa6bb5525ccaef45cd74460ee41" => :el_capitan
  end

  depends_on :xcode => :build # for docsetutil

  def install
    system "./configure", "--disable-debug",
                          "--enable-shared",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      int testfunc(char *string)
      {
        return string ? string[0] : 0;
      }
    EOS
    assert_match /testfunc/, shell_output("#{bin}/mxmldoc test.c")
  end
end
