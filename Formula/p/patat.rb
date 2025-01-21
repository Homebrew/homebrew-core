class Patat < Formula
  desc "Terminal-based presentations using Pandoc"
  homepage "https://github.com/jaspervdj/patat"
  url "https://hackage.haskell.org/package/patat-0.13.0.0/patat-0.13.0.0.tar.gz"
  sha256 "cb06567ed6cedc2cbba38151e1b3056576ce6d02e694d351027d8a008478860b"
  license "GPL-2.0-or-later"
  head "https://github.com/jaspervdj/patat.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "943c548cfa0b271a36c514017edfc6a5b4c58f9428cb063e81ece889768519cb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2c3961a124929b309509d6807fdb1b1da893fb0f9e3603722eae93b8057382e5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cdebdf1f3f4da54c2cbb1866772bae872486598e9aa6a0760e1d74f2498802a8"
    sha256 cellar: :any_skip_relocation, sonoma:        "a2d335b433f87cf622edbf4a4933965a769eeb74c93bbbc1ba4508df9373a449"
    sha256 cellar: :any_skip_relocation, ventura:       "8c7bcb1b23937dd5beae9ad24ae563b3a6c88aa03edb4c4565ee0f499776bee3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "679f9c8aec372ecbc3d3f35e540e6bb559bffe8563184f73921abf0d5b750a6a"
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
