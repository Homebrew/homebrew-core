class Highlight < Formula
  desc "Convert source code to formatted text with syntax highlighting"
  homepage "http://www.andre-simon.de/doku/highlight/en/highlight.html"
  url "http://www.andre-simon.de/zip/highlight-3.36.tar.bz2"
  sha256 "34cd5bcf52714f83364460c0c3551320564c56ff4e117353034e532275792171"
  head "https://github.com/andre-simon/highlight.git"

  bottle do
    sha256 "179f95d061b602625709cbc4aad5372f4877032db46e733eaaa08b07226fcc45" => :sierra
    sha256 "026f86ab725716c32c22eff4d41d754636a19accd58ae615916cecce3c65a8f3" => :el_capitan
    sha256 "3ac8d0948d20e9f0467b2b870d2c4ccb775b7b459a50b1322723ef89f31f586d" => :yosemite
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
