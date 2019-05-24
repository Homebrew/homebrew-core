class Highlight < Formula
  desc "Convert source code to formatted text with syntax highlighting"
  homepage "http://www.andre-simon.de/doku/highlight/en/highlight.php"
  url "http://www.andre-simon.de/zip/highlight-3.51.tar.bz2"
  sha256 "69ba1ebcfd3364227df03e5ad91078264757aaf6719c7844f727c38548a9a497"
  head "https://gitlab.com/saalen/highlight.git"

  bottle do
    sha256 "0ead27ee04c5119c117b418fdaaa611df8406e056648f6e544560cc4909a60ac" => :mojave
    sha256 "522793101a59250cb1d809c26b8f135984a3922fb27bdda7c1fd9954c20c7137" => :high_sierra
    sha256 "2619e61a294c034c811d9dc1d24de7b443d8060787dde36da9be998562e8124b" => :sierra
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
