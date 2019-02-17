class Highlight < Formula
  desc "Convert source code to formatted text with syntax highlighting"
  homepage "http://www.andre-simon.de/doku/highlight/en/highlight.php"
  url "http://www.andre-simon.de/zip/highlight-3.49.tar.bz2"
  sha256 "5299774e0d554c83c96001596d942b3c0a4e2884cc61026aed5d5b5730ad90fe"
  head "https://gitlab.com/saalen/highlight.git"

  bottle do
    sha256 "43594a4fa113c3f64fce9f1997ed27deaec21836f12099bec0c1a18eabefb71e" => :mojave
    sha256 "e44942388661087b8812111554d380d4f36c06cc44b5ac263d362db15d7bc001" => :high_sierra
    sha256 "1ee049c44b3f34358bfb2113cb8b4ce32d6122d273d3e91f5fbe22fc570f76ec" => :sierra
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
