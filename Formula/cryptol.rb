require "language/haskell"

class Cryptol < Formula
  include Language::Haskell::Cabal

  desc "Domain-specific language for specifying cryptographic algorithms"
  homepage "http://www.cryptol.net/"
  url "https://hackage.haskell.org/package/cryptol-2.4.0/cryptol-2.4.0.tar.gz"
  sha256 "d34471f734429c25b52ca71ce63270ec3157a8413eeaf7f65dd7abe3cb27014d"
  head "https://github.com/GaloisInc/cryptol.git"

  bottle do
    sha256 "c4f1f4823f79389a05325ed317bdb26bab0a9831446a2ffce7d6885d0bed2358" => :sierra
    sha256 "a5f2ee4dd5b97cd902df46add9279e1575bd053d0638cceb27df4d250952e1c7" => :el_capitan
    sha256 "605b746d10521d8b5de1c8711974eed1c929490e35417927f1ca000c477cd705" => :yosemite
    sha256 "baaf041702d1bd513e7ec73ee373224da009bdc7609ba13cd3aa2d6ca8141ae3" => :mavericks
  end

  depends_on "ghc" => :build
  depends_on "cabal-install" => :build
  depends_on "z3" => :run

  def install
    install_cabal_package :using => ["alex", "happy"]
  end

  test do
    (testpath/"helloworld.icry").write <<-EOS.undent
      :prove \\(x : [8]) -> x == x
      :prove \\(x : [32]) -> x + zero == x
    EOS
    expected = <<-EOS.undent
      Loading module Cryptol
      Q.E.D.
      Q.E.D.
    EOS
    assert_match expected, shell_output("#{bin}/cryptol -b helloworld.icry")
  end
end
