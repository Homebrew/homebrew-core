class Mighttpd2 < Formula
  desc "HTTP server"
  homepage "https://kazu-yamamoto.github.io/mighttpd2/"
  # TODO: Check if `cborg` allow-newer workarounds can be removed
  url "https://hackage.haskell.org/package/mighttpd2-4.0.9/mighttpd2-4.0.9.tar.gz"
  sha256 "6f85f533a232a9ab25f6758886beedcb1a8d8bcc0012bf73a7dac2ed291ca4e1"
  license "BSD-3-Clause"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "99f64d61207f727cffd821669446f5853cb5f6ef4fb73004415a3a98a245bd9e"
    sha256 cellar: :any,                 arm64_sequoia: "141ddf12baa00ebdb61710992d7a994575b20bc13387b9a37bff27cac4320a2b"
    sha256 cellar: :any,                 arm64_sonoma:  "f0c5a2f46297faa921320ab4b1e661f41abf4c6bdc45738a19cc540af57e9bbc"
    sha256 cellar: :any,                 sonoma:        "cc5290c3e3992f951543a3520209838ab7b6062f9664258295358f86f557d1b9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "67fbc95ab3285dc2bb03f7ac53b094258dca7d9ace439485c9b65164cc8f16f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c521f5c6d62571565f09f681499647ddda932207983409cc8d65fee2503e1b1b"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "gmp"

  uses_from_macos "libffi"

  on_linux do
    depends_on "zlib-ng-compat"
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
