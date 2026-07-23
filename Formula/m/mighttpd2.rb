class Mighttpd2 < Formula
  desc "HTTP server"
  homepage "https://kazu-yamamoto.github.io/mighttpd2/"
  # TODO: Check if `cborg` allow-newer workarounds can be removed
  url "https://hackage.haskell.org/package/mighttpd2-4.0.10/mighttpd2-4.0.10.tar.gz"
  sha256 "7512f967748517537f526cb1ff6c6bd4e896d432691dd14c613530071e8357db"
  license "BSD-3-Clause"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_tahoe:   "280ff0ef96b10fc2fa90a85a620ab251ad9bce32c749ec0edb0680ef6bdd5c97"
    sha256 cellar: :any, arm64_sequoia: "aa1206229e3f7a1560e0438ba6e8824022731a508871bcebefdc430dd295c4be"
    sha256 cellar: :any, arm64_sonoma:  "f8dfe4078c128bbb0473ab030d75575f9ca57dd5c965785628e5b926c9c2a864"
    sha256 cellar: :any, sonoma:        "bb58da7104fbb851cc94c347012b83721d2fff4237d58a1c7573cf747fe87e0f"
    sha256 cellar: :any, arm64_linux:   "7ff99bcd4001da18b6cec1e681367772a8aed55bd5177e4025a87c4ca8ec0de0"
    sha256 cellar: :any, x86_64_linux:  "847d6e27ad786f6f9ecf6ba750871052298484d5d3106226ece84e79c1263846"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "gmp"

  uses_from_macos "libffi"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  # Fix build with relaxed upper bounds of dependencies
  patch do
    url "https://github.com/kazu-yamamoto/mighttpd2/commit/68cdb3a2a98f66deff1ce85e8f8bc691d83c029e.patch?full_index=1"
    sha256 "e1a330e9842fb977ed4a7a4a7fb265526febe7b0f5b2f03726bfb6d7257d6818"
    type :backport
  end

  def install
    # Workaround to build aeson with GHC 9.14, https://github.com/haskell/aeson/issues/1155
    args = ["--allow-newer=base,containers,template-haskell"]

    system "cabal", "v2-update"
    system "cabal", "v2-install", "--flags=tls", *args, *std_cabal_v2_args
  end

  test do
    system bin/"mighty-mkindex"
    assert_predicate testpath/"index.html", :file?
  end
end
