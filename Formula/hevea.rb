class Hevea < Formula
  desc "LaTeX-to-HTML translator"
  homepage "http://hevea.inria.fr/"
  url "http://hevea.inria.fr/old/hevea-2.33.tar.gz"
  sha256 "abface4340f80692b4f1143f15dfabc16a263902a5025933020b42638d5d2504"

  bottle do
    rebuild 1
    sha256 "fc03dd618603653bbf60f56d5ac54609f1c684fba7a8a9aaddddb5c84aac82e7" => :catalina
    sha256 "f02097ca2ff65b7ee466ba597bb6d1c0a1fbbf381de3c3922cb31150fba941b7" => :mojave
    sha256 "527209a56a45e2e490978db70e8b2c6343a7e8e283fefeedfc6bb9cfe37843c0" => :high_sierra
    sha256 "b8b5d9cd3c34fe23a704e143b831284beda8601f6f6d037d37695016dc034a55" => :sierra
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
