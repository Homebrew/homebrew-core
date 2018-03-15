class Hevea < Formula
  desc "LaTeX-to-HTML translator"
  homepage "http://hevea.inria.fr/"
  url "http://hevea.inria.fr/old/hevea-2.31.tar.gz"
  sha256 "fbd7ad20aff45e557f5835f99a53d29a1753657cf2c004f26de83345b1b5b997"

  bottle do
    sha256 "b4ed09c5e29b302070a67251c8c87c56bca0817c704438fbd013fa5370bb0fbc" => :high_sierra
    sha256 "876829b6fea3a803ad583e0939fd7272618f1e82a21da4e73e0b581238dc34e0" => :sierra
    sha256 "5689cf43754e25c57bfea971d44186e737d73bab0f2489956861a98bcdb065a4" => :el_capitan
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
    (testpath/"test.tex").write <<~EOS
      \\documentclass{article}
      \\begin{document}
      \\end{document}
    EOS
    system "#{bin}/hevea", "test.tex"
  end
end
