class Hevea < Formula
  desc "LaTeX-to-HTML translator"
  homepage "http://hevea.inria.fr/"
  url "http://hevea.inria.fr/old/hevea-2.36.tar.gz"
  sha256 "5d6759d7702a295c76a12c1b2a1a16754ab0ec1ffed73fc9d0b138b41e720648"
  license all_of: [
    "QPL-1.0", # source files
    "GPL-2.0-only", # binaries
  ]

  livecheck do
    url "http://hevea.inria.fr/old/"
    regex(/href=.*?hevea[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "a1f2662024a74ebcb1a5fe6d6066030899abcd9586942136b19db4ecb36da59b"
    sha256 arm64_monterey: "c390ecca1b09d574110a2394049497f058b9fe2dec4a1cc89647b624dc91b404"
    sha256 arm64_big_sur:  "c1a1d50e902bf8aa644a33983ffde654d240f0d6101e25f838b8565ca6a1c576"
    sha256 ventura:        "d2b833d6882beedf115c34a4d385160179f3271cc6758f7b0e3cf12a0176406f"
    sha256 monterey:       "db2c216ff60400ea161cd163af81b5c62cb2749d3ba0109e4ec76d13f0f57d3a"
    sha256 big_sur:        "a583d051c2a5257acb2b60d9fdcacbafb63a6012c4d3f4aa293a5372020fb942"
    sha256 catalina:       "22faadcb4cf36deb5864e240ef5e7e718dbfd10308adb3582acbf53d653d082f"
    sha256 x86_64_linux:   "06f64e05150caebad2f34b80f2861b3c69fc4fa1a483d0863e269007d77de28b"
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
