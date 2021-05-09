class HaskellStack < Formula
  desc "Cross-platform program for developing Haskell projects"
  homepage "https://haskellstack.org/"
  url "https://github.com/commercialhaskell/stack/archive/v2.7.1.tar.gz"
  sha256 "eb849d5625084a6de57e8520ddf8172aca64ddadd9fee37cdafeefad80895b62"
  license "BSD-3-Clause"
  head "https://github.com/commercialhaskell/stack.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "2f6c0dc9279cc4dadc27305b448e1f27ac3f3f9189e667806b2f47ba323cc2e7"
    sha256 cellar: :any_skip_relocation, catalina: "a3e160e30048c2223853f8fd977797ed95e0fb198977c230fdc5397b610a1bb8"
    sha256 cellar: :any_skip_relocation, mojave:   "1e73da7200f3de9ca57d571ae707815c94b1737840dd16e5c260c15e682f5cbe"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build

  uses_from_macos "zlib"

  on_linux do
    depends_on "gmp"
  end

  def install
    system "cabal", "v2-update"

    cabal_install_constraints = ["--constraint=persistent^>=2.11.0.0", "--constraint=persistent-template^>=2.9.1.0"]
    system "cabal", "v2-install", *std_cabal_v2_args, *cabal_install_constraints
  end

  test do
    system bin/"stack", "new", "test"
    assert_predicate testpath/"test", :exist?
    assert_match "# test", File.read(testpath/"test/README.md")
  end
end
