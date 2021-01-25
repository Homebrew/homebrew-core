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
    sha256 "2f6c0dc9279cc4dadc27305b448e1f27ac3f3f9189e667806b2f47ba323cc2e7" => :big_sur
    sha256 "a3e160e30048c2223853f8fd977797ed95e0fb198977c230fdc5397b610a1bb8" => :catalina
    sha256 "1e73da7200f3de9ca57d571ae707815c94b1737840dd16e5c260c15e682f5cbe" => :mojave
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
