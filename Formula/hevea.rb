class Hevea < Formula
  desc "LaTeX-to-HTML translator"
  homepage "http://hevea.inria.fr/"
  url "http://hevea.inria.fr/old/hevea-2.35.tar.gz"
  sha256 "f189bada5d3e5b35855dfdfdb5b270c994fc7a2366b01250d761359ad66c9ecb"

  livecheck do
    url "http://hevea.inria.fr/old/"
    regex(/href=.*?hevea[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "851da4083db9aae8086e0d2f999a12da33601988c8d562d1f3e6d05f9bbc9a61"
    sha256 arm64_big_sur:  "83f3e0a6a87ad437058b5bdc840e4663dc1e57b5b34abf32b4f00a72ac436070"
    sha256 monterey:       "ee766667e58bab6f083fdd3d245b76da4a3fb2954e90314d381fc5f567b601f6"
    sha256 big_sur:        "7679aa58989eb2715fad0c5967407ce69b94bc3ec2aa7b3ad9fe7992be315858"
    sha256 catalina:       "6d654577f6c28ddd3c1029df88c7ecfce23dcc3ddac12fba90fc247abfcdb43e"
    sha256 mojave:         "6e0aa3139d0f799090295e989d8aa53d27b6d3735011ee9a8cedd85a0fd3b95b"
    sha256 x86_64_linux:   "ae4ae6db216b2bc7e0e2fa93fd64b9d04825a448507268c331c3a7e151736810"
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
