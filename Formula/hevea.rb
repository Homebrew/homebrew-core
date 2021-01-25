class Hevea < Formula
  desc "LaTeX-to-HTML translator"
  homepage "http://hevea.inria.fr/"
  url "http://hevea.inria.fr/old/hevea-2.35.tar.gz"
  sha256 "f189bada5d3e5b35855dfdfdb5b270c994fc7a2366b01250d761359ad66c9ecb"

  livecheck do
    url "http://hevea.inria.fr/old/"
    regex(/href=.*?hevea[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 "7679aa58989eb2715fad0c5967407ce69b94bc3ec2aa7b3ad9fe7992be315858" => :big_sur
    sha256 "6d654577f6c28ddd3c1029df88c7ecfce23dcc3ddac12fba90fc247abfcdb43e" => :catalina
    sha256 "6e0aa3139d0f799090295e989d8aa53d27b6d3735011ee9a8cedd85a0fd3b95b" => :mojave
  end

  depends_on "ocamlbuild" => :build
  depends_on "ocaml"

  def install
    ENV["PREFIX"] = prefix
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.tex").write <<~EOS
      \\documentclass{article}
      \\begin{document}
      \\end{document}
    EOS
    system "#{bin}/hevea", "test.tex"
  end
end
