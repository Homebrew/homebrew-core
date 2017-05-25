class Highlight < Formula
  desc "Convert source code to formatted text with syntax highlighting"
  homepage "http://www.andre-simon.de/doku/highlight/en/highlight.html"
  url "http://www.andre-simon.de/zip/highlight-3.36.tar.bz2"
  sha256 "34cd5bcf52714f83364460c0c3551320564c56ff4e117353034e532275792171"
  head "https://github.com/andre-simon/highlight.git"

  bottle do
    sha256 "2bdce4573b9b22e140864a64881be0c3bc6d0f9bcd9e6bf675c9f1918f9e5c45" => :sierra
    sha256 "e0749500a0c52285529468abf009ddfeb8573d82cf106d0838e97484ceefd599" => :el_capitan
    sha256 "e6faeaa3fffb136ffd73dbdc4cf7147f1f2aa7594e06195e213c2feb6699a2e3" => :yosemite
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
