class Highlight < Formula
  desc "Convert source code to formatted text with syntax highlighting"
  homepage "http://www.andre-simon.de/doku/highlight/en/highlight.php"
  url "http://www.andre-simon.de/zip/highlight-3.58.tar.bz2"
  sha256 "df80251be1f83adfc58aaad589fd9a8f9a3866b0d89b9f3c81b1696f07db45f8"
  license "GPL-3.0-or-later"
  head "https://gitlab.com/saalen/highlight.git"

  bottle do
    sha256 "81d79baca076097bd593e6d4376f26e1d6153138664ad9cb7cf6b08bcf80fb98" => :catalina
    sha256 "7b33c97698d9ef044fddfe1a579b2c8628970c29b4502c839524a2fafcbe1224" => :mojave
    sha256 "ed1984aab59c16059e508959be04cf5ec88b68718c06720dfd5f802d8ef81bfd" => :high_sierra
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
