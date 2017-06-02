class Highlight < Formula
  desc "Convert source code to formatted text with syntax highlighting"
  homepage "http://www.andre-simon.de/doku/highlight/en/highlight.html"
  url "http://www.andre-simon.de/zip/highlight-3.37.tar.bz2"
  sha256 "645a16ff3e4c175b731951ee409377b85c2959212641ae18a9a1e42e2bc985ba"
  head "https://github.com/andre-simon/highlight.git"

  bottle do
    sha256 "6125da34f8576b84e822ac5d7b3ea646ecd1f336c0af5abddc8cd49190f4711c" => :sierra
    sha256 "213160ca01d86d6f8b2a8e619caa17770082e822bb969eae2f40263f7faf235c" => :el_capitan
    sha256 "57f65a617ac023ae1bf6b1cef3f808b5f99604876ca75e2caacd3c6a9c6716b8" => :yosemite
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
