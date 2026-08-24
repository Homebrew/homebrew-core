class Hevea < Formula
  desc "LaTeX-to-HTML translator"
  homepage "https://hevea.inria.fr/"
  url "https://hevea.inria.fr/old/hevea-2.38.tar.gz"
  sha256 "722038065007226f0fa3de4629127294d2e29bfbbc41042c83a570fa0c455a47"
  license all_of: [
    "QPL-1.0", # source files
    "GPL-2.0-only", # binaries
  ]
  revision 1

  livecheck do
    url "https://hevea.inria.fr/old/"
    regex(/href=.*?hevea[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "7adec0a68d97c8aa59a28322012169104df01b8e690673cb929a05fb773623e0"
    sha256 arm64_sequoia: "d76ea47bca0a2df7900e6ae6e6cec15f8c3faecf1debcb33b2849fccd12510a9"
    sha256 arm64_sonoma:  "0e91ca0dd3705101d51598f6f8046eeacab49f8a117431b68583008d6ecfb8ab"
    sha256 sonoma:        "691dd44898b2be35dd30128fd36402786b81484c78cc403f8044b786cb2d2277"
    sha256 arm64_linux:   "d6dc20bf781879c8d9021b4dfcde5ecdc23451d6a722640ae5b90ba7dedf0d4f"
    sha256 x86_64_linux:  "19d843f8b251e66fd43d6c4c1be42c20af8faf2cb4aaac756887064e9a22f263"
  end

  depends_on "ocamlbuild" => :build
  depends_on "ocaml"

  def install
    ENV["PREFIX"] = prefix
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.tex").write <<~'TEX'
      \documentclass{article}
      \begin{document}
      \end{document}
    TEX
    system bin/"hevea", "test.tex"
  end
end
