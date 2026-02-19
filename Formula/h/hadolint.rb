class Hadolint < Formula
  desc "Smarter Dockerfile linter to validate best practices"
  homepage "https://github.com/hadolint/hadolint"
  url "https://github.com/hadolint/hadolint/archive/refs/tags/v2.14.0.tar.gz"
  sha256 "002a411ac608696327d65aaa6e77c8fafe2561429ce56cca0ccb67c2956f8dd5"
  license "GPL-3.0-only"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "5fb72dd7116d76a9c78806853ed98d4da2f15f8ca46c9f5511ef66e3c9c36225"
    sha256 cellar: :any,                 arm64_sequoia: "7af3406142276fb1dfe68ed7211fe9bca1e348114de6390c53f08dc5d11b5c3c"
    sha256 cellar: :any,                 arm64_sonoma:  "29512bf0e04e72b3085f88b9240bb30c91665b622c1d8cc2d7c961d985280a47"
    sha256 cellar: :any,                 sonoma:        "d3fb60d34da4c25bde58751038a8b9d794fe6c9863e5a945250bfa7877e5446b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f6bbbbade4308b73a44f059afe1d9926e0d787ba9a48d1508789a74d7913d0ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e5b8c9a91f19e10eced2063d35eb89e54c239e0270caed1a3ff72afd62292674"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "gmp"

  uses_from_macos "libffi"
  uses_from_macos "xz"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    # Workaround for GHC 9.12 until https://github.com/phadej/puresat/pull/7
    # and base is updated in https://github.com/phadej/spdx
    # Workaround to build aeson with GHC 9.14, https://github.com/haskell/aeson/issues/1155
    args = ["--allow-newer=base,containers,template-haskell"]

    system "cabal", "v2-update"
    system "cabal", "v2-install", *args, *std_cabal_v2_args
  end

  test do
    df = testpath/"Dockerfile"
    df.write <<~DOCKERFILE
      FROM debian
    DOCKERFILE
    assert_match "DL3006", shell_output("#{bin}/hadolint #{df}", 1)
  end
end
