class Pdfcrack < Formula
  desc "PDF files password cracker"
  homepage "https://pdfcrack.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/pdfcrack/pdfcrack/pdfcrack-0.16/pdfcrack-0.16.tar.gz"
  sha256 "7865b203074ccfd5c612c8ce00c46ffcb4fabaa26154ce9304dfc668c7cb73ef"

  bottle do
    cellar :any_skip_relocation
    sha256 "536c58b929d56ecd58787a99806ba35eb77c6d84e685c768ac340a2565868538" => :mojave
    sha256 "267ea30516a748d4e47e36608dbac86b4447ce1f27b96c8333f7866a1787128d" => :high_sierra
    sha256 "aa99f4d2cdf38a95b2ce720875c446a83a15f4b912d09e6b70e41caa5e95cf55" => :sierra
    sha256 "56e86ec915cc0f470b12a7f5ce22afb12d03a79bc99285a71503fbea1769204d" => :el_capitan
  end

  def install
    system "make", "all"
    bin.install "pdfcrack"
  end

  test do
    system "#{bin}/pdfcrack", "--version"
  end
end
