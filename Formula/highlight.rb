class Highlight < Formula
  desc "Convert source code to formatted text with syntax highlighting"
  homepage "http://www.andre-simon.de/doku/highlight/en/highlight.php"
  url "http://www.andre-simon.de/zip/highlight-3.61.tar.bz2"
  sha256 "b3d0b1fafffd01d45a96e8ac0e981d18814e7482df3f9e0b499c6be9e0d1a970"
  license "GPL-3.0-or-later"
  head "https://gitlab.com/saalen/highlight.git"

  bottle do
    sha256 arm64_big_sur: "03766e3933b3fd02d4ef399053750d27019f935f70116cd13d9c1f532c902a72"
    sha256 big_sur:       "9a7c7481b761f6e679d1d23fa43096ed0f7634e4fd8d6819212cb16d5c92da99"
    sha256 catalina:      "574afc4567ba334842f54e3b1383f887b85787acdfd7ed00236d4226ea7ea239"
    sha256 mojave:        "8700ff1859f02d5453d3ceac994424f531d76f21f965557b043cecc1d07bf9e4"
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
