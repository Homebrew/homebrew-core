class Htmldoc < Formula
  desc "Convert HTML to PDF or PostScript"
  homepage "https://www.msweet.org/htmldoc/"
  url "https://github.com/michaelrsweet/htmldoc/releases/download/v1.9.3/htmldoc-1.9.3-source.tar.gz"
  sha256 "d44140c8121423a372996f8d0cbaecd5f783e2b62d933f20314905a93625d48c"
  head "https://github.com/michaelrsweet/htmldoc.git"

  bottle do
    sha256 "293e519b1f45009a7af3751e6373eb5e001b233d3de349b47522b48206d374f0" => :mojave
    sha256 "127a8c2832a800ad89e5925cb0a34b84a405c535d46267b80e8c53eecc363f2b" => :high_sierra
    sha256 "bab767a8ea4093422d480a9fde4d0156eb9509f3bac026886f174d43cfdf325d" => :sierra
    sha256 "7a1a44691173eb534dad23b2991fc7f0d4cfa2471dba7cea1d24ab16ce058f58" => :el_capitan
  end

  depends_on "libpng"
  depends_on "jpeg"

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
