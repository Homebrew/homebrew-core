class Highlight < Formula
  desc "Convert source code to formatted text with syntax highlighting"
  homepage "http://www.andre-simon.de/doku/highlight/en/highlight.html"
  url "http://www.andre-simon.de/zip/highlight-3.31.tar.bz2"
  sha256 "c78cdce3c8133736c3bc2f931d34cb69c09e043c9ce681251e26a9f9b19c4c6d"

  head "svn://svn.code.sf.net/p/syntaxhighlight/code/highlight/"

  bottle do
    sha256 "bd408e591ddd6474a778d015016a95561a08e81cf85f9f326faa49a9f23d3e08" => :el_capitan
    sha256 "dbd688da510b4e7a5f0254e85807a59b77796b85e0894a070892b9a7dd7841ed" => :yosemite
    sha256 "dd69eedefa6a6325e15e5b874da8a47166368cbd6a0be3a232d964983edf762e" => :mavericks
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
