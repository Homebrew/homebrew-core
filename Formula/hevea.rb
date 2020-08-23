class Hevea < Formula
  desc "LaTeX-to-HTML translator"
  homepage "http://hevea.inria.fr/"
  url "http://hevea.inria.fr/old/hevea-2.34.tar.gz"
  sha256 "3ad08a0dce6675df3caa912ec1497d8019ce10733263092bbb7482c4fbd7fedf"

  bottle do
    sha256 "34fd968c75f335330d256da9ad1b3e39b65b4286deb36810f898a6a729794b41" => :catalina
    sha256 "780ecfdaaac0985d9d9a6ef2b92c966d101144637bb65c41880f9b71c27c3c13" => :mojave
    sha256 "851ce38d9468eee9b2548f303e1e9d029e863dadcf90caa68039b8615b5acf07" => :high_sierra
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
