class Highlight < Formula
  desc "Convert source code to formatted text with syntax highlighting"
  homepage "http://www.andre-simon.de/doku/highlight/en/highlight.html"
  url "http://www.andre-simon.de/zip/highlight-3.31.tar.bz2"
  sha256 "c78cdce3c8133736c3bc2f931d34cb69c09e043c9ce681251e26a9f9b19c4c6d"

  head "svn://svn.code.sf.net/p/syntaxhighlight/code/highlight/"

  bottle do
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
