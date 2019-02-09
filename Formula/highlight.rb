class Highlight < Formula
  desc "Convert source code to formatted text with syntax highlighting"
  homepage "http://www.andre-simon.de/doku/highlight/en/highlight.php"
  url "http://www.andre-simon.de/zip/highlight-3.49.tar.bz2"
  sha256 "5299774e0d554c83c96001596d942b3c0a4e2884cc61026aed5d5b5730ad90fe"
  head "https://gitlab.com/saalen/highlight.git"

  bottle do
    sha256 "cef2ac3e71e17a4f11ed512cb50f3c37bc16001e4800a19985f2c370a118069e" => :mojave
    sha256 "66fa9326e507db6407d6013a230cf459064c2b09186129e2dfb79a9002da4f6c" => :high_sierra
    sha256 "c8a473714718b83f6284b02035d4cdff9168976006fd0654d504b833e7c2f51e" => :sierra
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
