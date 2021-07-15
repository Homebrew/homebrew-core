class Htmldoc < Formula
  desc "Convert HTML to PDF or PostScript"
  homepage "https://www.msweet.org/htmldoc/"
  url "https://github.com/michaelrsweet/htmldoc/archive/v1.9.12.tar.gz"
  sha256 "abeb50b9a0247fee4a83af98c56ba3bc35804f593af1893899de084830315a05"
  license "GPL-2.0-only"
  head "https://github.com/michaelrsweet/htmldoc.git"

  bottle do
    sha256 arm64_big_sur: "8ad42fb09ec7e7662e97d8cf68e80ced7b24d0c3a32ad19786eeda91244bec9a"
    sha256 big_sur:       "c7ab042a45cd07798d05f04b3cdd46c0f8d074f77afff3de08674b967693031e"
    sha256 catalina:      "19e6c50efd7951727889db86a576d9d0f2ef277930918d71e9a1f051867cbe2f"
    sha256 mojave:        "e0f1dd77114431b572ede01a58a59a3464fe463b7166941d27d649a88283af95"
    sha256 x86_64_linux:  "cb85c4ccbadbbc8cc2b5dfed686c506a631442119f0a27744c3a42acf6997c06"
  end

  depends_on "pkg-config" => :build
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
