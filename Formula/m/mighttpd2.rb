class Mighttpd2 < Formula
  desc "HTTP server"
  homepage "https://kazu-yamamoto.github.io/mighttpd2/"
  # TODO: Check if `cborg` allow-newer workarounds can be removed
  url "https://hackage.haskell.org/package/mighttpd2-4.0.10/mighttpd2-4.0.10.tar.gz"
  sha256 "7512f967748517537f526cb1ff6c6bd4e896d432691dd14c613530071e8357db"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "66fbd63b606e13da4d46baebd96a6a26de5dc555553ede663a49be878d6091d7"
    sha256 cellar: :any,                 arm64_sequoia: "3bd15fc041272bcc6acba9fc872d3a14b4fe3dc500f1e3db04e0e3077ac49c81"
    sha256 cellar: :any,                 arm64_sonoma:  "144cc74e8f72513a0791956190136c19373f2b456876f5172bb455f64e7c46b9"
    sha256 cellar: :any,                 sonoma:        "1d87006977c3e8d4d4f64ee888e52c14dab67d14011d5f4d9f333739f10cf8e5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e5d0a2d98d44a5f042aa42c95129f90ea90fe6a8355cf047f9545924c00d1867"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "61f34699423a6e6e60e12776b21141712b2220b27b515365a469f4bfa41214ec"
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
