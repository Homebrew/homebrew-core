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
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "121879456dcdc6371f30ab0c8aa67d78427606a0ad9fcbdc9ad45328a347a33b"
    sha256 cellar: :any,                 arm64_sequoia: "a65793c6e5498bf09af0c891b2869a9f02a320a128d578047210936fbf50fe8e"
    sha256 cellar: :any,                 arm64_sonoma:  "2b1564b33b1bdfee78317be1d9a03b308be08a8aaf5dd749245e36648d73f71c"
    sha256 cellar: :any,                 sonoma:        "1bafa7b9f646a6a07cc551f7054fa948edf4cc002de6c4422921018048a6a3a6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "069483cb58b0ec25eeba1b59d13ad79df363382279da79a586c787fa94a9b17c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7f28f2e70c2267cff776985a30da56bfb00384168ed904d405003ac606fe3d83"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "pandoc" => :build
  depends_on "pkgconf" => :build
  depends_on "gmp"

  uses_from_macos "libffi"
  uses_from_macos "zlib"

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args
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
