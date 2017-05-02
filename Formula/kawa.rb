class Kawa < Formula
  desc "Programming language for Java (implementation of Scheme)"
  homepage "https://www.gnu.org/software/kawa/"
  url "https://ftp.gnu.org/gnu/kawa/kawa-2.4.zip"
  mirror "https://ftpmirror.gnu.org/kawa/kawa-2.4.zip"
  sha256 "bab0f623a15ad2b3ab74253f446a670b3019d59edf7db7ec22059fe41fa1e6ab"

  bottle :unneeded

  depends_on :java => "1.7+"

  def install
    rm Dir["bin/*.bat"]
    inreplace "bin/kawa", "thisfile=`type -p \$0`",
                          "thisfile=#{libexec}/bin/kawa"
    libexec.install "bin", "lib"
    bin.install_symlink libexec/"bin/kawa"
    doc.install Dir["doc/*"]
  end

  test do
    system bin/"kawa", "-e", "(import (srfi 1))"
  end
end
