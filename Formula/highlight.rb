class Highlight < Formula
  desc "Convert source code to formatted text with syntax highlighting"
  homepage "http://www.andre-simon.de/doku/highlight/en/highlight.html"
  url "http://www.andre-simon.de/zip/highlight-3.34.tar.bz2"
  sha256 "1ea4ff989d192a0c2538f7b18683f41829596800e9f6fecf58d9d621218664bb"
  head "svn://svn.code.sf.net/p/syntaxhighlight/code/highlight/"

  bottle do
    sha256 "71ec6876cf2721b4c9bfebe50a67180bd655b78ce516fe821c9f6e7cd44bfb61" => :sierra
    sha256 "fb21c1eeff2e1fdd59c888ecd2072c7aca8540d3922e4f8853b070feab34e988" => :el_capitan
    sha256 "199291e27b269ae831bc3c32995d93d9e0000773c48edf677c4b4145782c7b5e" => :yosemite
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
