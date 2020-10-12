class Cryptol < Formula
  desc "Domain-specific language for specifying cryptographic algorithms"
  homepage "https://www.cryptol.net/"
  url "https://hackage.haskell.org/package/cryptol-2.9.1/cryptol-2.9.1.tar.gz"
  sha256 "b430d59d9391ddc0506117b08b952412291a142856d8d2cf912f26a4e8258830"
  license "BSD-3-Clause"
  head "https://github.com/GaloisInc/cryptol.git"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "360d274aa0f54cb0f5645e6df403bfb354b2c8b8fcd38a84de752b31c0f333f1" => :catalina
    sha256 "ac8b4bbf496c2be8affdae694bcb162cbdf2f0539e9616a9c4291d09e6247a66" => :mojave
    sha256 "11052ebd61ac8398f0ccf79e9e5bc5ba94df7423805546e9b318a543e8c0606a" => :high_sierra
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "z3"

  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  # Fix dependencies https://github.com/GaloisInc/cryptol/issues/879
  # Remove in next version
  patch do
    url "https://github.com/GaloisInc/cryptol/commit/f35fe362.diff?full_index=1"
    sha256 "7deab78a33582f456b354d2230b4f7faeff526127910d1f6c9b77cf63c16dcfd"
  end

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args
  end

  test do
    (testpath/"helloworld.icry").write <<~EOS
      :prove \\(x : [8]) -> x == x
      :prove \\(x : [32]) -> x + zero == x
    EOS
    expected = /Q\.E\.D\..*Q\.E\.D/m
    assert_match expected, shell_output("#{bin}/cryptol -b helloworld.icry")
  end
end
