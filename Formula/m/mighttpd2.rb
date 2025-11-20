class Mighttpd2 < Formula
  desc "HTTP server"
  homepage "https://kazu-yamamoto.github.io/mighttpd2/"
  # TODO: Check if `cborg` allow-newer workarounds can be removed
  url "https://hackage.haskell.org/package/mighttpd2-4.0.9/mighttpd2-4.0.9.tar.gz"
  sha256 "6f85f533a232a9ab25f6758886beedcb1a8d8bcc0012bf73a7dac2ed291ca4e1"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "fb9506a6f447163871a2b4d66ff4d95ed4151818ba2125d17ee3194514bb92a7"
    sha256 cellar: :any,                 arm64_sequoia: "25be6975363a119562cc5652ae9eebb7219552713f104774fb8fe514214add76"
    sha256 cellar: :any,                 arm64_sonoma:  "c50ef2cd7f27b3a323e7c76c0653938869db33f655c301ef1ec251da7ce51cad"
    sha256 cellar: :any,                 arm64_ventura: "d407f151b2dbc11fbdfca89ca0eca2a8055b62e6f5986682e9457edb449aabae"
    sha256 cellar: :any,                 sonoma:        "b869e08498f909fe812222cb770e0eedae952c43d9fa81e73cca18f8993bf1ad"
    sha256 cellar: :any,                 ventura:       "8135c1643f100ca500668f35926b65673d6a7d38cb8c7a704b8db43088e183b8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7d5c8695c575fb1ab553398737a123cb27a5516b96ad019fe76a3cb08d79b8d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b3743ce97574c778c753f505fdb3b4822d65562532462375105d12ad394f57e9"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "gmp"

  uses_from_macos "libffi"
  uses_from_macos "zlib"

  def install
    # Workaround to build with GHC 9.12, remove after https://github.com/well-typed/cborg/pull/339
    # is merged and available on Hackage or if `cborg` is willing to provide a metadata revision
    args = ["--allow-newer=serialise:base,serialise:ghc-prim,cborg:base,cborg:ghc-prim"]

    system "cabal", "v2-update"
    system "cabal", "v2-install", "--flags=tls", *args, *std_cabal_v2_args
  end

  test do
    system bin/"mighty-mkindex"
    assert_predicate testpath/"index.html", :file?
  end
end
