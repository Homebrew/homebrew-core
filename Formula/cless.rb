require "language/haskell"

class Cless < Formula
  include Language::Haskell::Cabal

  desc "Display file contents with colorized syntax highlighting"
  homepage "https://github.com/tanakh/cless"
  url "https://github.com/tanakh/cless/archive/0.3.0.0.tar.gz"
  sha256 "382ad9b2ce6bf216bf2da1b9cadd9a7561526bfbab418c933b646d03e56833b2"
  revision 1

  bottle do
    cellar :any_skip_relocation
    rebuild 2
    sha256 "3244447865fa989bf33235e88637e0d6c19032c7a2d099c1c0fc7645d0cd043e" => :mojave
    sha256 "b0f4cd35cfb88bae1816f87df9a6eac25ffc5b68bc03ed7d92c8bba493add8c1" => :high_sierra
    sha256 "3585e128d1f855aede1e5bb6adec957c64e6777b126cc93a4165d68ccc304038" => :sierra
    sha256 "660d59f6fe5f0b319091559c727a8b1b241f62244b877fc35ecdf34d69bf7713" => :el_capitan
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build

  def install
    # GHC 8 compat
    # Reported 25 May 2016: https://github.com/tanakh/cless/issues/3
    # Also see "fix compilation with GHC 7.10", which has the base bump but not
    # the transformers bump: https://github.com/tanakh/cless/pull/2
    (buildpath/"cabal.config").write("allow-newer: base,transformers\n")

    install_cabal_package
  end

  test do
    system "#{bin}/cless", "--help"
    system "#{bin}/cless", "--list-langs"
    system "#{bin}/cless", "--list-styles"
  end
end
