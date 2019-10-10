class Htmldoc < Formula
  desc "Convert HTML to PDF or PostScript"
  homepage "https://www.msweet.org/htmldoc/"
  url "https://github.com/michaelrsweet/htmldoc/archive/v1.9.7.tar.gz"
  sha256 "bbd7befc5aaf7f999b96010e887679e4107413df7803b3d50a6240e0d9abf402"
  head "https://github.com/michaelrsweet/htmldoc.git"

  bottle do
    sha256 "3817f4de69634444205b0368f2e657851b2e73fceb63a70b77697a945dfba788" => :mojave
    sha256 "22689d93e1257349bd0f89406c74728afb8b93b9ad5c9f6de5331d4b110b308a" => :high_sierra
    sha256 "d7ff6b4d2e3a32ac482af05a7f52b643c528f5fcc31622b46e85e8be3c95f2ae" => :sierra
  end

  depends_on "jpeg"
  depends_on "libpng"

  def install
    system "./configure", "--disable-debug",
                          "--disable-ssl",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/htmldoc", "--version"
  end
end
