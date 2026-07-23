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
      type :backport
    end
  end

  bottle do
    rebuild 3
    sha256 cellar: :any, arm64_tahoe:   "03e84a0cdfb59b453fb6b9cd4351b59c8a9287a3097b1bc9bff077892bb59a16"
    sha256 cellar: :any, arm64_sequoia: "1e0c475a35d23f87451dd54c16ba46a4f3be52d28c4ccc944515b735d42c1da8"
    sha256 cellar: :any, arm64_sonoma:  "2d2225afc359f0241e0986c82eefb75ccfd7b5b589b05b53213d099bdadc6d41"
    sha256 cellar: :any, sonoma:        "4ec7119a84b0fe9f8d6cce16b88c36a6d7ba2aca7788681612c10b1dcc61f273"
    sha256 cellar: :any, arm64_linux:   "daeb16652d5773835524d1c2e29cf181e01bc34b405c9c43c53e8dd0bb6e6053"
    sha256 cellar: :any, x86_64_linux:  "4e109ffdd3a69f4ad1314319c45b7edb64f8247289c9acbdcd0f178b4be4cb1e"
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
