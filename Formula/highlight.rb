class Highlight < Formula
  desc "Convert source code to formatted text with syntax highlighting"
  homepage "http://www.andre-simon.de/doku/highlight/en/highlight.php"
  url "http://www.andre-simon.de/zip/highlight-3.53.tar.bz2"
  sha256 "2d81f552c663bc3b9dee4cd575c2044c26fe9af0e9b771e4579dc47facc7aec9"
  head "https://gitlab.com/saalen/highlight.git"

  bottle do
    sha256 "73750c1713102910c732b2e7c0ac54974efad2f01849ad82f817ba34718766ce" => :mojave
    sha256 "fb77c226417840a773fe11ffb2112bdf5283704965cae188e8b05d29586692f8" => :high_sierra
    sha256 "1fcddca7deb63f3b1f6cc7233c78ebeb4e847f7ee83678733eda819bd4925b4b" => :sierra
  end

  depends_on "boost" => :build
  depends_on "pkg-config" => :build
  depends_on "lua"

  def install
    conf_dir = etc/"highlight/" # highlight needs a final / for conf_dir
    system "make", "PREFIX=#{prefix}", "conf_dir=#{conf_dir}"
    system "make", "PREFIX=#{prefix}", "conf_dir=#{conf_dir}", "install"
  end

  test do
    system bin/"highlight", doc/"extras/highlight_pipe.php"
  end
end
