class Hevea < Formula
  desc "LaTeX-to-HTML translator"
  homepage "https://hevea.inria.fr/"
  url "https://hevea.inria.fr/old/hevea-2.38.tar.gz"
  sha256 "722038065007226f0fa3de4629127294d2e29bfbbc41042c83a570fa0c455a47"
  license all_of: [
    "QPL-1.0", # source files
    "GPL-2.0-only", # binaries
  ]

  livecheck do
    url "https://hevea.inria.fr/old/"
    regex(/href=.*?hevea[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "807e064c4a8f903cd9ef077f1e272392e2a4ca4a4c4f5ba370ade28637c07ac5"
    sha256 arm64_sequoia: "9e91fe2232484d28116dcd15e582753ab92e3b51f1f951caea28914357467247"
    sha256 arm64_sonoma:  "6f9908f7e88641bb865999655faef19943fcc78264df848377d53f3f5a8c5cef"
    sha256 sonoma:        "4abee9f15ba945b2a7e9df32509827f3fa79388dc4f15f371d0eaa3ab4b79687"
    sha256 arm64_linux:   "dbf9630c685fe8d90adce84c80cfda8d3c915f86d02a44fc78835e5bac20298a"
    sha256 x86_64_linux:  "d44b4d1c07b514272c2cbdaf70590061b965879e23c57dd5c361323fad5e7e23"
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
