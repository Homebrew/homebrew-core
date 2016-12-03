class Highlight < Formula
  desc "Convert source code to formatted text with syntax highlighting"
  homepage "http://www.andre-simon.de/doku/highlight/en/highlight.html"
  url "http://www.andre-simon.de/zip/highlight-3.33.tar.bz2"
  sha256 "64b530354feccabc3e8eeec02a0341be0625509db1fa5dd201c4d07e4d845c3c"
  head "svn://svn.code.sf.net/p/syntaxhighlight/code/highlight/"

  bottle do
    sha256 "0e0b5a6ce08ef6e007e442ad27fdaf8e8229c28f5d03fa7b23d3388218dd3303" => :sierra
    sha256 "eff4f5323affe30dcc734277971442c8bb8dff968c56e44cb23c85da5e0efab4" => :el_capitan
    sha256 "30b5bc8958c29900e3f23ad788d8c04b0dd0a1423fe6ea10d2b930fc59bbdfe3" => :yosemite
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
