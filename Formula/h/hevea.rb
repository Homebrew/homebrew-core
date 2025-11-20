class Hevea < Formula
  desc "LaTeX-to-HTML translator"
  homepage "https://hevea.inria.fr/"
  url "https://hevea.inria.fr/old/hevea-2.37.tar.gz"
  sha256 "b6e93f07f58179d65b4eb7e8c4a5d5f68b4a25f104c029a62fc9154e93e1af59"
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
    sha256 arm64_tahoe:   "2dad7f2a6d3cf2a346593282072be814ad5f8f57c20976ee5f0c23f22d37893d"
    sha256 arm64_sequoia: "72ef2c482c6328417af06c69b5e956da2498bf9767d1f3721f7e26be851a6d01"
    sha256 arm64_sonoma:  "fd90a40c8b66d0f0769dd21d86ea89cf3d1c06b9fad0d06c1e7ce03eb25e492b"
    sha256 arm64_ventura: "1c951275c426b92660fb49b80c041026b8ea797b5ad05c2b42a8e28d75550823"
    sha256 sonoma:        "b592684ffb9c4c0923ad667deb61ab371441fd7903531f2825cbc2f999d3374b"
    sha256 ventura:       "212fdcf104ea94dca7feeee48a16ab2e98df23dba8f5997ad91c3918cc6c32a0"
    sha256 arm64_linux:   "e43cac91f14e4acc816c57ee0b9456bae2df9ecd3093322ffdc3cec8169355da"
    sha256 x86_64_linux:  "e7ada6088c57473900c761cfda4e0b97c14f7d929eab4f4bb38f8847ff4e41c8"
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
