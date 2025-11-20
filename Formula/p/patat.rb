class Patat < Formula
  desc "Terminal-based presentations using Pandoc"
  homepage "https://github.com/jaspervdj/patat"
  url "https://hackage.haskell.org/package/patat-0.15.2.0/patat-0.15.2.0.tar.gz"
  sha256 "d1f182ecdf145b8db1aacee1c4d46731d197b192e6ef855c3505067c1cea2b65"
  license "GPL-2.0-or-later"
  head "https://github.com/jaspervdj/patat.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "00aa976ca5fdacc86e38303a701c6b39f69c66dc71df0737d797222981f377f5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "90b7a9394554857c0a8535126c47949d931a7f659e4e70026cc7c3de14d3feb9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cd312988933bf91ab8ed3c458ddfc17d084a37347f18021ce5633c53980435fa"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d92ea4a497a9bfa9f1697058c421881cb94f8dea121b676d0dbdd3e158351aaa"
    sha256 cellar: :any_skip_relocation, sonoma:        "a06c67fb2863949481fc857ead7592b89e464aab11530a61a41a93e4f89aef1e"
    sha256 cellar: :any_skip_relocation, ventura:       "5704db30193d278c0ba64e99bb67f426b19cbd7899fcbf293d294432e8d5a989"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fc042157bd5597b79314b5b08f3f7baf4289e1d31fe410d00af0462489cb2a6e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e117d456e17b90dec4429df57ed91c429144578f20c8e5b9f99c75f0d4e3d304"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc@9.10" => :build
  depends_on "pandoc" => :build
  depends_on "pkgconf" => :build

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
