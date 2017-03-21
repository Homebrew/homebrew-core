class Highlight < Formula
  desc "Convert source code to formatted text with syntax highlighting"
  homepage "http://www.andre-simon.de/doku/highlight/en/highlight.html"
  url "http://www.andre-simon.de/zip/highlight-3.35.tar.bz2"
  sha256 "8a14b49f5e0c07daa9f40b4ce674baa00bb20061079473a5d386656f6d236d05"
  revision 1
  head "https://svn.code.sf.net/p/syntaxhighlight/code/highlight/"

  bottle do
    sha256 "7c32a92de8de5008868253aa16ed0f6608f9813a2b26ac9eb244dbec4ba95a8f" => :sierra
    sha256 "62f97bf51b5950497d0ab761292bce67e7f1ddc629438f9a994e5db9be28510f" => :el_capitan
    sha256 "e980a33e61a872957470d732cd67c2cd4c202ec26d624b93eeffc81c97bfd399" => :yosemite
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
