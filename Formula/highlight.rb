class Highlight < Formula
  desc "Convert source code to formatted text with syntax highlighting"
  homepage "http://www.andre-simon.de/doku/highlight/en/highlight.php"
  url "http://www.andre-simon.de/zip/highlight-3.44.tar.bz2"
  sha256 "53a1191f1b21130d9690e4c9a82947af11777d8e9569446b997c5a824e601fa4"
  head "https://gitlab.com/saalen/highlight.git"

  bottle do
    sha256 "f256350386e3ad4ebaa7ce95a23a5cddff2d51e4ad7523ed1786ea1d9aa81e16" => :high_sierra
    sha256 "ae33ca016fac875560c6ea7c3a3a48df924c90e8d5214be677e5faf797862235" => :sierra
    sha256 "c98962533f512140baec718d595db361bb9f75d7a5a9e73581cdbb9178749cb6" => :el_capitan
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
