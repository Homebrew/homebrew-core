class Highlight < Formula
  desc "Convert source code to formatted text with syntax highlighting"
  homepage "http://www.andre-simon.de/doku/highlight/en/highlight.html"
  url "http://www.andre-simon.de/zip/highlight-3.41.tar.bz2"
  sha256 "3909986041d40b1d0d3e00cb3b6043b0fbff6fd6a452696fb4eec495b6536722"
  head "https://github.com/andre-simon/highlight.git"

  bottle do
    sha256 "7e2983c2c56792522f97380ddbfd99d93e8a40f4ed5428270b7c890679c5e90e" => :high_sierra
    sha256 "013d843a52cafc3b39eab427af44595250929c74ec80b89d0071a02a43bfb39e" => :sierra
    sha256 "6fb88c3313c25802ddc3dc72db6c9d6e5aef7287bed86ee42c5319098bc37fab" => :el_capitan
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
