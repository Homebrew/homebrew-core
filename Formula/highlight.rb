class Highlight < Formula
  desc "Convert source code to formatted text with syntax highlighting"
  homepage "http://www.andre-simon.de/doku/highlight/en/highlight.html"
  url "http://www.andre-simon.de/zip/highlight-3.32.tar.bz2"
  sha256 "c54e495319b5b0781a672615763978d5300b3065fa4e02ec9c69b0cafe930c9d"
  head "svn://svn.code.sf.net/p/syntaxhighlight/code/highlight/"

  bottle do
    sha256 "d4820e0f870f0038003e8ce2aa98ffeb3d12ab87d95fd2dd4c1950cca7c44f67" => :sierra
    sha256 "cc4d0e5c5560c537be229b894ed263599dc8c70de2e3bb66378c201cb163bd9d" => :el_capitan
    sha256 "fbef995efd8cdddec4c5dbbc55d787ffe789143337998f70f844d25ea7e84a3b" => :yosemite
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
