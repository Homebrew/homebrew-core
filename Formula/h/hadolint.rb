class Hadolint < Formula
  desc "Smarter Dockerfile linter to validate best practices"
  homepage "https://github.com/hadolint/hadolint"
  url "https://github.com/hadolint/hadolint/archive/refs/tags/v2.13.1.tar.gz"
  sha256 "5df6d6b7c20c28588488665206259d3c9bb326d06401d5b8ce37fcfefb1a2e0e"
  license "GPL-3.0-only"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "8dc7e9d3c068d317903f5b0a3d841fec7c81a02e334d8d1b16e117e791ad5296"
    sha256 cellar: :any,                 arm64_sequoia: "a8c8a959da09c91b1c95707a9586304d5367d449ca353a4604a53da364550766"
    sha256 cellar: :any,                 arm64_sonoma:  "1e539279669993dd266bb253e5a1763e6b9377286a40a16c3d2d030f9dde82fb"
    sha256 cellar: :any,                 arm64_ventura: "84e67e5b2bf0024a2bfb20c1f7dc1cf353935f21d6a622cac1ad56da2927be75"
    sha256 cellar: :any,                 sonoma:        "99ed84c4a9889ffd1e95aabad886962f6710dd98d424102ea56199b66c6ef660"
    sha256 cellar: :any,                 ventura:       "9649bde21226ebda516272008eff6fac396bba91da9dad237bb3592da3dd4362"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ea5354ecd233492c184aea444239a50b5e7a1940430d75f9fcd88bbdbd22a8ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0aef999abd4360dcca387038ac90178963832093cc7187b03692e33c1bbb91c7"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "gmp"

  uses_from_macos "libffi"
  uses_from_macos "xz"
  uses_from_macos "zlib"

  def install
    # Workaround for GHC 9.12 until https://github.com/phadej/puresat/pull/7
    # and base is updated in https://github.com/phadej/spdx
    args = ["--allow-newer=puresat:base,spdx:base"]

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
