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
    sha256 arm64_sequoia: "7025aafe3bbdcee08882372ff76d2cebf0c6d37d9b159bdc5957f4c1e82dc567"
    sha256 arm64_sonoma:  "ea000f6db0d00dbd4e5897fb9d7ec6b1b8aa37777f5267782590aa0421ae04a2"
    sha256 arm64_ventura: "a40fe4e3d3503fad65005a6a00d4db7d2460ad1e1610a60484f5d0dce85bc751"
    sha256 sonoma:        "09a2ea99788409f3e159b05bc394cc440e35d91142613e295e9fc45a3a8d8cb5"
    sha256 ventura:       "896ce48b7854700b6ae3467e3694c1d16340535a740090b2eb708ce6986ca90b"
    sha256 arm64_linux:   "3935374d459ad43db0d40878f8b4a3d2822d6f3c57eab3247e8975e8d338b508"
    sha256 x86_64_linux:  "13bfac3c45d8d2632cd8b2579c8ab559ed7fac9b6feb7ae24eb8ced30542beb1"
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
