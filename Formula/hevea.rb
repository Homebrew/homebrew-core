class Hevea < Formula
  desc "LaTeX-to-HTML translator"
  homepage "http://hevea.inria.fr/"
  url "http://hevea.inria.fr/old/hevea-2.28.tar.gz"
  sha256 "cde2000e4642f3f88d73a317aec54e8b6036e29e81a00262daf15aca47d0d691"
  revision 1

  bottle do
    sha256 "00d05e38a39e27a8e4d12913266e75f39ad46fcd327e134098dea14602dd67cf" => :sierra
    sha256 "a9356d96f3fc49905f11abeb69cae214bbf55c6d00b001c84307b50ae077a5c8" => :el_capitan
    sha256 "b79a483b56128142ed9ff0207e2dffbb676a86d1af8acc7f26562976567739b1" => :yosemite
  end

  depends_on "ocaml"
  depends_on "ocamlbuild" => :build
  depends_on "ghostscript" => :optional

  def install
    ENV["PREFIX"] = prefix
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.tex").write <<-EOS.undent
      \\documentclass{article}
      \\begin{document}
      \\end{document}
    EOS
    system "#{bin}/hevea", "test.tex"
  end
end
