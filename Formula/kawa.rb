class Kawa < Formula
  desc "Programming language for Java (implementation of Scheme)"
  homepage "https://www.gnu.org/software/kawa/"
  url "https://ftp.gnu.org/gnu/kawa/kawa-3.1.zip"
  mirror "https://ftpmirror.gnu.org/kawa/kawa-3.1.zip"
  sha256 "c4c3abb5d4f3eab526299150e073685f29e5416fa4f9b025e06d31ce17d1c739"

  bottle :unneeded

  depends_on :java => "1.7+"

  def install
    rm Dir["bin/*.bat"]
    inreplace "bin/kawa", "thisfile=`command -v $0`",
                          "thisfile=#{libexec}/bin/kawa"
    libexec.install "bin", "lib"
    bin.install_symlink libexec/"bin/kawa"
    doc.install Dir["doc/*"]
  end

  test do
    system bin/"kawa", "-e", "(import (srfi 1))"
  end
end
