class Hevea < Formula
  desc "LaTeX-to-HTML translator"
  homepage "http://hevea.inria.fr/"
  url "http://hevea.inria.fr/old/hevea-2.32.tar.gz"
  sha256 "de55c6809ae077cd9b2cd5c758449907845677258815c96a713764e6e0c59ee8"

  bottle do
    sha256 "0f9ecfeeca0ddc19b5dc05c1439be84c6956fb4f60507d933215f17f8c98c892" => :mojave
    sha256 "3449e59de08edb173696ded7a21127ea8bb7cae445eb2d0db6e814d5c84ae6bf" => :high_sierra
    sha256 "ac0e31ca981ad566e978ab954a324aead767b60ebab55be36f081689d3ffd8c3" => :sierra
    sha256 "b036e8c8233b6800187efaab19171c39f25c4d82b8ba32442abdec688aa61296" => :el_capitan
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
