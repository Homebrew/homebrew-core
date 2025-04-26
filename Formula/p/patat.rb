class Patat < Formula
  desc "Terminal-based presentations using Pandoc"
  homepage "https://github.com/jaspervdj/patat"
  url "https://hackage.haskell.org/package/patat-0.15.0.0/patat-0.15.0.0.tar.gz"
  sha256 "7fbd8fb0acaa6a076cc80fb6ac94b8eb02ee2eac524af842ddee9802eab855ed"
  license "GPL-2.0-or-later"
  head "https://github.com/jaspervdj/patat.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6922262a5456b9f2c0fb6d035f4b48ea5c31eabf54bfab3396b7832af525df75"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7752af0892c87f4e1e4b8ab6b176cda21c06c9e9fff30253a174feee9ca4b604"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1d74d8ef26abb5124378368df7fdf4d74943b2a48ef97d77858031232e5368e6"
    sha256 cellar: :any_skip_relocation, sonoma:        "c8c5c4de61348f06d137c102c5adb6ca5c2e87c592e7d149dd8ba868c7058ee3"
    sha256 cellar: :any_skip_relocation, ventura:       "637694b462ba2b5d2fd2bfdde614e34b9d1fde8b90496fbd2fbdbd0e081fc822"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6390067a6165e948ac19e1acbc7fd963f65ba9c75ea651a7fbebf22b4645023f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cd3d53ae252d26191e0afda4140ea3a2e1d6f671e2d7326f05ba7789119a21a8"
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
