class Mighttpd2 < Formula
  desc "HTTP server"
  homepage "https://kazu-yamamoto.github.io/mighttpd2/"
  url "https://hackage.haskell.org/package/mighttpd2-4.0.11/mighttpd2-4.0.11.tar.gz"
  sha256 "bf8cceeb34339c9357d489b133653c77e8f12a89350bed9e0873f6c1978ef6fc"
  license "BSD-3-Clause"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "9873b4b3f124e544476c386b65f07e0173928e20908feb084852ea700a802e06"
    sha256 cellar: :any, arm64_tahoe:       "280ff0ef96b10fc2fa90a85a620ab251ad9bce32c749ec0edb0680ef6bdd5c97"
    sha256 cellar: :any, arm64_sequoia:     "aa1206229e3f7a1560e0438ba6e8824022731a508871bcebefdc430dd295c4be"
    sha256 cellar: :any, arm64_sonoma:      "f8dfe4078c128bbb0473ab030d75575f9ca57dd5c965785628e5b926c9c2a864"
    sha256 cellar: :any, sonoma:            "bb58da7104fbb851cc94c347012b83721d2fff4237d58a1c7573cf747fe87e0f"
    sha256 cellar: :any, arm64_linux:       "7ff99bcd4001da18b6cec1e681367772a8aed55bd5177e4025a87c4ca8ec0de0"
    sha256 cellar: :any, x86_64_linux:      "847d6e27ad786f6f9ecf6ba750871052298484d5d3106226ece84e79c1263846"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "gmp"

  uses_from_macos "libffi"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  deny_network_access!

  # Workaround to build aeson with GHC 9.14, https://github.com/haskell/aeson/issues/1155
  def cabal_args = ["--flags=tls", "--allow-newer=base,containers,template-haskell"]

  def fetch
    system "cabal", "v2-update"
    system "cabal", "v2-install", "--only-download", *cabal_args, *std_cabal_v2_args
  end

  def install
    system "cabal", "v2-install", *cabal_args, *std_cabal_v2_args
  end

  test do
    system bin/"mighty-mkindex"
    assert_predicate testpath/"index.html", :file?
  end
end
