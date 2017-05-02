class Latex2html < Formula
  desc "LaTeX-to-HTML translator"
  homepage "https://www.ctan.org/pkg/latex2html"
  url "http://mirrors.ctan.org/support/latex2html/latex2html-2016.tar.gz"
  sha256 "ab1dbc18ab0ec62f65c1f8c14f2b74823a0a2fc54b07d73ca49524bcae071309"

  bottle do
    cellar :any_skip_relocation
    sha256 "96aba432faa475b5201a84d032e5e4e90d95264e23387ba20bd59fea5d06403b" => :sierra
    sha256 "093a49aaa3b77c884b9e7aa7ebcff872dc763a984c779fa03b3a50013c311ea1" => :el_capitan
    sha256 "6a304d1b869c3bdb472c4eea5b4251e626a89446c3d55443da81bbbbe626a59c" => :yosemite
  end

  depends_on "netpbm"
  depends_on "ghostscript"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--without-mktexlsr",
                          "--with-texpath=#{share}/texmf/tex/latex/html"
    system "make", "install"
  end
end
