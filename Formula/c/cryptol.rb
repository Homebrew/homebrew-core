class Cryptol < Formula
  desc "Domain-specific language for specifying cryptographic algorithms"
  homepage "https://galoisinc.github.io/cryptol/master/RefMan.html"
  url "https://hackage.haskell.org/package/cryptol-3.6.0/cryptol-3.6.0.tar.gz"
  sha256 "cc0a7ef3b20f4543386209b9077c0d9064c22e0db81f30e8ab4cc8f5dc4a8d93"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/GaloisInc/cryptol.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "e0954bc152744c95e1a4fcc9906413003dd04f0656c214dbd0a8a2f42e13fab0"
    sha256 cellar: :any, arm64_tahoe:       "f3d0a0295ad14f3049a3c90d1b9c18d946c3a28efd25ab41820d1037f9c31077"
    sha256 cellar: :any, arm64_sequoia:     "27d07d49485c5507677ece6f0e73f2c2237b521eb758698c3d500949515db27a"
    sha256 cellar: :any, arm64_linux:       "06943dea01ca9f8b1e30a85668ac35ad210352f777b48f9b35635d19a77424a8"
    sha256 cellar: :any, x86_64_linux:      "31b45aacbf5cf51fb3aa3bf364b268f5e37a16c4d1776e7176d3b154a3c05c08"
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
