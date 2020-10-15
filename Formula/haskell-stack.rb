class HaskellStack < Formula
  desc "Cross-platform program for developing Haskell projects"
  homepage "https://haskellstack.org/"
  url "https://github.com/commercialhaskell/stack/archive/v2.5.1.tar.gz"
  sha256 "f29d63b91ff2bddd130b29ddee90a1f450706271a13d5d80b653b50379ffa076"
  license "BSD-3-Clause"
  head "https://github.com/commercialhaskell/stack.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "0e72e5dcc47ad2a71d842bde6aa742a0ae87d68d5fc22c948db6585d2be400da" => :catalina
    sha256 "4407ef8eb595ebd28d5d2a1256c0356466cd4239a2b95e99ffd02b0b306a7ffb" => :mojave
    sha256 "4f3617f2778d5f30f46c8a6c20ccbe7ea4488332734b9b8ca399e476b6dfd03f" => :high_sierra
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build

  uses_from_macos "zlib"

  on_linux do
    depends_on "gmp"
  end

  # Support build with persistent-2.11 and optparse-applicative-0.16
  patch do
    url "https://github.com/commercialhaskell/stack/commit/7796eaa6b2c6c5e8a579af34ebc33b12d73b6c99.patch?full_index=1"
    sha256 "58aa8a861307c14068148a88bf8f46ed7fe2e3c89a3c8bfd1949316e2d7dab29"
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
