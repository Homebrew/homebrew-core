class Htmldoc < Formula
  desc "Convert HTML to PDF or PostScript"
  homepage "https://www.msweet.org/htmldoc/"
  url "https://github.com/michaelrsweet/htmldoc/archive/v1.9.11.tar.gz"
  sha256 "eaa994270dc05ab52d57ed738128370ba783989e97687801fe3c12f445af0d05"
  license "GPL-2.0-only"
  head "https://github.com/michaelrsweet/htmldoc.git"

  bottle do
    sha256 "6029b20fee4277640dd030fd67fcd6ad7c44eaaf090ca081b5ff8b187014cbbb" => :big_sur
    sha256 "a6187a1e4079f05e4c98576177e837d9534c5a789b9217472ab5ea5bf7c9212e" => :arm64_big_sur
    sha256 "40fde97e24aec401f49b7428cc8849f5147f7f59276f4f2908ee87cdf235155d" => :catalina
    sha256 "c5634ea6546a2ec88f4c2a16084be6a45d512aac294daec1d25b15f10ce7a942" => :mojave
    sha256 "b4450990fe8964fcdcbb95dc5dde28789e226b928bde992dfb2817f238561ac4" => :high_sierra
  end

  depends_on "jpeg"
  depends_on "libpng"

  def install
    system "./configure", "--disable-debug",
                          "--disable-ssl",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/htmldoc", "--version"
  end
end
