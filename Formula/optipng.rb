class Optipng < Formula
  desc "PNG file optimizer"
  homepage "https://optipng.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/optipng/OptiPNG/optipng-0.7.7/optipng-0.7.7.tar.gz"
  sha256 "4f32f233cef870b3f95d3ad6428bfe4224ef34908f1b42b0badf858216654452"
  head "http://hg.code.sf.net/p/optipng/mercurial", :using => :hg

  bottle do
    cellar :any_skip_relocation
    sha256 "093c6a64c408594726d3bbf646394d1bec0ff05e95e8a71b7ca244afb67929ee" => :catalina
    sha256 "150c2cace53963fa77b40e30e403fea731ac87ce3aa5bf0528205f3bcd0626ab" => :mojave
    sha256 "b64e8d6bd75de2e40d481c7b0e816f45b0865e2dfa42f03e507f67607804ef2b" => :high_sierra
    sha256 "416ce24daab37aaef4fecda949fc80bed2b1d9b9714406f972b093846578ab3a" => :sierra
    sha256 "f59e3cedb808003915ee214f6487b968e3e6dcea669452f0a732fcced03aaa8f" => :el_capitan
  end

  def install
    system "./configure", "--with-system-zlib",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"
  end

  test do
    system "#{bin}/optipng", "-simulate", test_fixtures("test.png")
  end
end
