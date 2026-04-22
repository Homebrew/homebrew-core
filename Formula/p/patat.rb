class Patat < Formula
  desc "Terminal-based presentations using Pandoc"
  homepage "https://github.com/jaspervdj/patat"
  license "GPL-2.0-or-later"
  head "https://github.com/jaspervdj/patat.git", branch: "main"

  stable do
    url "https://hackage.haskell.org/package/patat-0.15.2.0/patat-0.15.2.0.tar.gz"
    sha256 "d1f182ecdf145b8db1aacee1c4d46731d197b192e6ef855c3505067c1cea2b65"

    # Backports relaxed dependency constraints to build with GHC >= 9.12
    patch do
      url "https://github.com/jaspervdj/patat/commit/16d568bc414f4f0ced8b4f897c3584fd82a7797a.patch?full_index=1"
      sha256 "1a0f9aa653b9dd8b47acbdaabee3b50b557b87ca8d2c364a85a8f8b8ec637abc"
    end
  end

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_tahoe:   "5078a6ef677ef802f2f78ca950c5e0d756ec8058a00ac43c990af4cc42b641e5"
    sha256 cellar: :any,                 arm64_sequoia: "a959da2b101e50e8066aa852735b17ef36976a7d72bcd6af8c8e069e02352b79"
    sha256 cellar: :any,                 arm64_sonoma:  "bb22958819bdc12b2d484ebfd732513d7f370f096d460f5010bdd029967a7d3c"
    sha256 cellar: :any,                 sonoma:        "027fcd9e810e61b16f996ba16d4406b56c77f0928db0001eea1c2a1904e40fcd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bddf7b47c06f8906f627ef84ff4105e87e75777f4e6d6cdc3f834804e5702813"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fb2810208b1abbb9b541d3eb0d576bce58c57e4af2c0b1ddad3dd465138dc962"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "pandoc" => :build
  depends_on "pkgconf" => :build
  depends_on "gmp"

  uses_from_macos "libffi"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    # Workaround to build aeson with GHC 9.14, https://github.com/haskell/aeson/issues/1155
    args = ["--allow-newer=base,containers,template-haskell"]

    system "cabal", "v2-update"
    system "cabal", "v2-install", *args, *std_cabal_v2_args
  end

  test do
    test_file = testpath/"test.md"
    test_file.write <<~MARKDOWN
      # Hello from Patat
      Slide 1
      ---
      Slide 2
    MARKDOWN
    output = shell_output("#{bin}/patat --dump --force #{test_file}")
    assert_match "Hello from Patat", output

    assert_match version.to_s, shell_output("#{bin}/patat --version")
  end
end
