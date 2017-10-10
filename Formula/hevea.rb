class Hevea < Formula
  desc "LaTeX-to-HTML translator"
  homepage "http://hevea.inria.fr/"
  url "http://hevea.inria.fr/old/hevea-2.31.tar.gz"
  sha256 "fbd7ad20aff45e557f5835f99a53d29a1753657cf2c004f26de83345b1b5b997"

  bottle do
    sha256 "a431a61f899ba34d9d233f9c0ebaf54dbaf2c5a4967fc9f7fc90f0a673eeebd2" => :high_sierra
    sha256 "b22f4a1e66c2eea6faecf98834a0897334e77684312653885049835c593ad431" => :sierra
    sha256 "079afe1b83d43ea8c3e5537d199ba20ee05a6460db653df0675948390b328b94" => :el_capitan
    sha256 "4b6005785553fdd3185d7b15c74f9e8ab0632994bc6cd714ece9148203589609" => :yosemite
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
