class Hevea < Formula
  desc "LaTeX-to-HTML translator"
  homepage "http://hevea.inria.fr/"
  url "http://hevea.inria.fr/old/hevea-2.28.tar.gz"
  sha256 "cde2000e4642f3f88d73a317aec54e8b6036e29e81a00262daf15aca47d0d691"

  bottle do
    sha256 "efeffbf5b155e15de0501e9810f295a2d95f2d112784aa9df21e515fed88dfbe" => :sierra
    sha256 "10e296d23ed1c0fea468cc9f3aeece0d79f69a2c67a76c854d54a1391907d326" => :el_capitan
    sha256 "ea7d096a0541ffa6b79161e38defcd733425766ac692d059645c318331fa586a" => :yosemite
    sha256 "4944a42656a2ca467e3e4a4b76bb8805337639408a374184a0d67a1cdf21af6a" => :mavericks
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
