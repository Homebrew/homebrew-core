class Htmldoc < Formula
  desc "Convert HTML to PDF or PostScript"
  homepage "https://www.msweet.org/projects.php?Z1"
  url "https://github.com/michaelrsweet/htmldoc/releases/download/v1.9.1/htmldoc-1.9.1-source.tar.gz"
  sha256 "cbee52b9e6f5485086db1b86d7ed0609925fef325a88cf96a6d11a5859117094"
  head "https://github.com/michaelrsweet/htmldoc.git"

  bottle do
    sha256 "a5cb80a8a89142e19ccfb556f7f1e6cf237a79a1533aa5edf259417a86b7c033" => :high_sierra
    sha256 "524ad03f947350cd7724ea078d7c0671a857bb20c0ff394efd3cfd9d4dd078b9" => :sierra
    sha256 "2bf69586aaec539be7069cdfdd21e611ee784165ff6b74bcdaf56ca80b9c0539" => :el_capitan
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
