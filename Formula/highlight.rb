class Highlight < Formula
  desc "Convert source code to formatted text with syntax highlighting"
  homepage "http://www.andre-simon.de/doku/highlight/en/highlight.html"
  url "http://www.andre-simon.de/zip/highlight-3.32.tar.bz2"
  sha256 "c54e495319b5b0781a672615763978d5300b3065fa4e02ec9c69b0cafe930c9d"
  head "svn://svn.code.sf.net/p/syntaxhighlight/code/highlight/"

  bottle do
    sha256 "ec4200f59bbbf066ece050cd82bea6e95b84828ee6952b05eaa4ee4bc72abe24" => :sierra
    sha256 "1906c96427e933e28dc03199977666d619242d726766a29b266ca91fb4c3fec2" => :el_capitan
    sha256 "e4bf63f82f28bca0f27fa367dc2830fa57d2a612f0efe917971267bdf1c7fe19" => :yosemite
    sha256 "59af0526be758e166f508b7fd23abf3c2aade1cfa97288ea572ef734fe2d437c" => :mavericks
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
