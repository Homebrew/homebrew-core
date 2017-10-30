class Kawa < Formula
  desc "Programming language for Java (implementation of Scheme)"
  homepage "https://www.gnu.org/software/kawa/"
  url "https://ftp.gnu.org/gnu/kawa/kawa-3.0.zip"
  mirror "https://ftpmirror.gnu.org/kawa/kawa-3.0.zip"
  sha256 "63116eec4b2b2dd8fae0b30127639aa42ad7a7430c4970d3fd76b42a148e423c"

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
