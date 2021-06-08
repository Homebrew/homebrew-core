class HaskellStack < Formula
  desc "Cross-platform program for developing Haskell projects"
  homepage "https://haskellstack.org/"
  url "https://github.com/commercialhaskell/stack/archive/v2.7.1.tar.gz"
  sha256 "eb849d5625084a6de57e8520ddf8172aca64ddadd9fee37cdafeefad80895b62"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/commercialhaskell/stack.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "f8c509beacc6ad13fafcdd6fe754880e8420e045303671b37979f6cf8c84e81e"
    sha256 cellar: :any_skip_relocation, catalina: "77b634ce8c96d01f0d55c86858322030a4b17a55c835fa9acb90b3b3c30ce302"
    sha256 cellar: :any_skip_relocation, mojave:   "26e6f6d71967378f63659a0232cec8968d1635332ca8714c2467d653b5beb9e7"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "llvm" => :build if Hardware::CPU.arm?

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
