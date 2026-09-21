class Cryptol < Formula
  desc "Domain-specific language for specifying cryptographic algorithms"
  homepage "https://galoisinc.github.io/cryptol/master/RefMan.html"
  url "https://hackage.haskell.org/package/cryptol-3.6.0/cryptol-3.6.0.tar.gz"
  sha256 "cc0a7ef3b20f4543386209b9077c0d9064c22e0db81f30e8ab4cc8f5dc4a8d93"
  license "BSD-3-Clause"
  head "https://github.com/GaloisInc/cryptol.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "303f6348e97a04a95a8ead0a78a9d7bdbaab60d377083b0a66cc3e382113fba2"
    sha256 cellar: :any, arm64_tahoe:       "1e0748ff426bc45146700c63c6a8ea62ae1a6658a8f37edb8c1baced0d9ad864"
    sha256 cellar: :any, arm64_sequoia:     "11956f02bd241b63274e4766a199a41ca5af5dd7df1ec039ece66226cc5abb3f"
    sha256 cellar: :any, arm64_sonoma:      "53b5ac834ca52aeb3042bb5c9c90a0e9e706e08a846f0c8e4e8a113344182110"
    sha256 cellar: :any, arm64_linux:       "92e70eb1a9cbd848f549ff66ae0f402de72cd91f3e17580552dddedba91a1d3b"
    sha256 cellar: :any, x86_64_linux:      "9f098fca45d638c40553d0bb166fb0a1b3c377d131758047f26b2b9501b604cb"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc@9.12" => :build
  depends_on "gmp"
  depends_on "z3"

  uses_from_macos "libffi"
  uses_from_macos "ncurses"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  deny_network_access!

  def fetch
    system "cabal", "v2-update"
    system "cabal", "v2-install", "--only-download", *std_cabal_v2_args
  end

  def install
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
