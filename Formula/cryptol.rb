class Cryptol < Formula
  desc "Domain-specific language for specifying cryptographic algorithms"
  homepage "https://www.cryptol.net/"
  url "https://hackage.haskell.org/package/cryptol-2.9.0/cryptol-2.9.0.tar.gz"
  sha256 "2bcbf4ad6c1679a17f47467bf6eab250deea8e5125c53535c44afa4af525bd2f"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/GaloisInc/cryptol.git"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "de12794d8334f69f857bb269a0e9dc4368e7f6a2968284d70854bad8e1247707" => :catalina
    sha256 "89a27a902bac68fb5e22b542cc9513d5a2035782d9dd060957e5eb85f772666b" => :mojave
    sha256 "5df9e6a56e9555948e2bdb058ce87b50bf2885a85ff97c1bf5f7879c27ab22ac" => :high_sierra
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "z3"

  uses_from_macos "ncurses"
  uses_from_macos "zlib"

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
