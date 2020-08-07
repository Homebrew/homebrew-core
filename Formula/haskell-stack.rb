class HaskellStack < Formula
  desc "The Haskell Tool Stack"
  homepage "https://haskellstack.org/"
  url "https://github.com/commercialhaskell/stack/archive/v2.3.3.tar.gz"
  sha256 "57042c0c7b53a6f8dba7f31679e9049c28351a86b8bc2786f7e37eda4733634e"
  license "BSD-3-Clause"
  head "https://github.com/commercialhaskell/stack.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "de6d561271fd1a422e4b4e85e9d71fd0cd87870d524e984aec3caab4762753ed" => :catalina
    sha256 "bffb38f057df538f22407b0c7e62cf224f60851b4845f8ef3cd7ee603f030fed" => :mojave
    sha256 "00038523c213ac96e759c01108a9867a55afc6ba3ea32646962493f29667b702" => :high_sierra
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build

  uses_from_macos "zlib"

  on_linux do
    depends_on "gmp"
  end

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args
  end

  test do
    system bin/"stack", "new", "test"
    assert_predicate testpath/"test", :exist?
    assert_match "# test", File.read(testpath/"test/README.md")
  end
end
