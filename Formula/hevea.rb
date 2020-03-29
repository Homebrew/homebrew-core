class Hevea < Formula
  desc "LaTeX-to-HTML translator"
  homepage "http://hevea.inria.fr/"
  url "http://hevea.inria.fr/old/hevea-2.34.tar.gz"
  sha256 "3ad08a0dce6675df3caa912ec1497d8019ce10733263092bbb7482c4fbd7fedf"

  bottle do
    sha256 "56225d900e9394a1eaf18cc3ccaa7acc38b91c52afc1d089aab89101ee617064" => :catalina
    sha256 "660b2a335b60cbf727597ceac10879ff1f563d4ca07dba4ff1a0ff500ecaa8c5" => :mojave
    sha256 "c814d37b48e369ff326c4ff32dd8d4fd83e41967f28ddc5390033fdd8643f77a" => :high_sierra
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
