class Highlight < Formula
  desc "Convert source code to formatted text with syntax highlighting"
  homepage "http://www.andre-simon.de/doku/highlight/en/highlight.html"
  url "http://www.andre-simon.de/zip/highlight-3.38.tar.bz2"
  sha256 "c017d817e397d2d98c9264f63af2613a011bcbdcac53a92d3d540ae0978807fb"
  head "https://github.com/andre-simon/highlight.git"

  bottle do
    sha256 "67fbfa4306a1b437a527580e33ce9e80fb5e964f044687f617464e235015320a" => :sierra
    sha256 "1bd7041d5fa39dde83138b4acc5798e4d904cc6c09cfd36b2b736aa9116ba1a6" => :el_capitan
    sha256 "15f7d483c79b6d7fc29ab166bc96eeb83f1672114c2781365c737782a73d027f" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "lua"

  def install
    conf_dir = etc/"highlight/" # highlight needs a final / for conf_dir
    system "make", "PREFIX=#{prefix}", "conf_dir=#{conf_dir}"
    system "make", "PREFIX=#{prefix}", "conf_dir=#{conf_dir}", "install"
  end

  test do
    system bin/"highlight", doc/"examples/highlight_pipe.php"
  end
end
