class Kawa < Formula
  desc "Programming language for Java (implementation of Scheme)"
  homepage "https://www.gnu.org/software/kawa/"
  url "https://ftp.gnu.org/gnu/kawa/kawa-2.3.zip"
  mirror "https://ftpmirror.gnu.org/kawa/kawa-2.3.zip"
  sha256 "76431f9acd758df8c1a7c16d8a4fde91b625bb14c730e5ea6540bca6b724ef5a"

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
