class Htmldoc < Formula
  desc "Convert HTML to PDF or PostScript"
  homepage "https://www.msweet.org/projects.php?Z1"
  url "https://github.com/michaelrsweet/htmldoc/releases/download/v1.9.1/htmldoc-1.9.1-source.tar.gz"
  sha256 "cbee52b9e6f5485086db1b86d7ed0609925fef325a88cf96a6d11a5859117094"
  head "https://github.com/michaelrsweet/htmldoc.git"

  bottle do
    sha256 "ef2cadb84906c2094010582fa0e00062bd730e6084c1a03f2467bd3a3a0fa04e" => :high_sierra
    sha256 "c34dd52990fcf2454678e81787709fd41a1d0cc7024eed82438676d7aed1c62d" => :sierra
    sha256 "0ef48c9bdff878f3293fc187700a926854d565a3060e444e29386c44b3e5ec6b" => :el_capitan
    sha256 "d0b5adc798dbcdfdc9a5ae242904fae7c85f65af5b696b9b49f3d7018fcaf703" => :yosemite
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
end
