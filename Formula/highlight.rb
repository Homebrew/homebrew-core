class Highlight < Formula
  desc "Convert source code to formatted text with syntax highlighting"
  homepage "http://www.andre-simon.de/doku/highlight/en/highlight.html"
  url "http://www.andre-simon.de/zip/highlight-3.41.tar.bz2"
  sha256 "3909986041d40b1d0d3e00cb3b6043b0fbff6fd6a452696fb4eec495b6536722"
  revision 1
  head "https://github.com/andre-simon/highlight.git"

  bottle do
    sha256 "18239da8e84df78c67ec1dc10877caab6cb3faf93540c9b1d0bbc9f8804a0cd6" => :high_sierra
    sha256 "fe61de37a2db2790c59acfe023f85e98a6e48d8c5ddbf6d0f945a0cc85f04343" => :sierra
    sha256 "71347886a307e30dd344118fdd36ee874a059dfa5af23a49ed5bf4e42cac2d79" => :el_capitan
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
