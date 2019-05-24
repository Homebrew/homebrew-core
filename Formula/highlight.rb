class Highlight < Formula
  desc "Convert source code to formatted text with syntax highlighting"
  homepage "http://www.andre-simon.de/doku/highlight/en/highlight.php"
  url "http://www.andre-simon.de/zip/highlight-3.51.tar.bz2"
  sha256 "69ba1ebcfd3364227df03e5ad91078264757aaf6719c7844f727c38548a9a497"
  head "https://gitlab.com/saalen/highlight.git"

  bottle do
    sha256 "fb2b5f288ecd87694069e860fdccdb103f154ab884317675c64e38c5e4679ed5" => :mojave
    sha256 "e713c9b32d2cdb085b3b963d9779b21127aa08473b07556c931b848d52a96174" => :high_sierra
    sha256 "64b0d8d2c6418e33dc39b04223bfffa5219850e9ef73cf902b5e3bbed1d6f91a" => :sierra
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
