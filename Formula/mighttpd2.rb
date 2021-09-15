class Mighttpd2 < Formula
  desc "HTTP server"
  homepage "https://www.mew.org/~kazu/proj/mighttpd/en/"
  url "https://hackage.haskell.org/package/mighttpd2-3.4.6/mighttpd2-3.4.6.tar.gz"
  sha256 "fe14264ea0e45281591c86030cad2b349480f16540ad1d9e3a29657ddf62e471"
  license "BSD-3-Clause"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "1651ee812cb2ed4e64cc1f6ba81d9d8e783aa6c357759c1dcc4021972976ac81"
    sha256 cellar: :any_skip_relocation, big_sur:       "f4825cfc94adb7f0d47ca4dcaa3b924726845eef22dafa8a9603c6efe8a3e24d"
    sha256 cellar: :any_skip_relocation, catalina:      "bcea435a9feba47df19b64d9fac972a1df8f580647204b07a73b2ade2e14c479"
    sha256 cellar: :any_skip_relocation, mojave:        "68e563757fb405de41a4312c03f7b72da99586430ea8f0aff98fdab48213635f"
    sha256 cellar: :any_skip_relocation, high_sierra:   "7b033c6ce128310465134a09bae1ef3df9cb630db732167a06028c1a5773576e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6fedabb209c288efc21b4283c34609645a9882f18a525ca48b1e2ccfd1d70b10"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build

  uses_from_macos "zlib"

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", "-ftls", *std_cabal_v2_args
  end

  test do
    system "#{bin}/mighty-mkindex"
    assert (testpath/"index.html").file?
  end
end
