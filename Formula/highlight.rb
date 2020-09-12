class Highlight < Formula
  desc "Convert source code to formatted text with syntax highlighting"
  homepage "http://www.andre-simon.de/doku/highlight/en/highlight.php"
  url "http://www.andre-simon.de/zip/highlight-3.58.tar.bz2"
  sha256 "df80251be1f83adfc58aaad589fd9a8f9a3866b0d89b9f3c81b1696f07db45f8"
  license "GPL-3.0"
  head "https://gitlab.com/saalen/highlight.git"

  bottle do
    sha256 "243c2078603d4f83e931300382e2aaa21972251a99ebe50b822e673bd358a502" => :catalina
    sha256 "6030a1c16c514c91897d6ab538f5ec6f41efffbecfe836df7e7edda555f15b2e" => :mojave
    sha256 "cc27431c8f13763d6c75b377345e324f16060eebdd1687fbf40b0b2331ea1c89" => :high_sierra
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
