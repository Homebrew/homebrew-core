class Patat < Formula
  desc "Terminal-based presentations using Pandoc"
  homepage "https://github.com/jaspervdj/patat"
  url "https://hackage.haskell.org/package/patat-0.15.1.0/patat-0.15.1.0.tar.gz"
  sha256 "390b15031d20f8bd9d03e51e11bd9248af00aa437930300be34668b458be1ed9"
  license "GPL-2.0-or-later"
  head "https://github.com/jaspervdj/patat.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "12f6a51fd4fc98ba4481653c769909f311bceaf5856a59bff1bb21c17ce331c9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7992bf8e61e761dcc008656039673b936c9ceaff87d934901ca6cfbdf812dcae"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d1f51a89f3724b8d2abfda576553c7d7a42d5332b4b1be1d3a9ff251b366845b"
    sha256 cellar: :any_skip_relocation, sonoma:        "9c1fd12d64c68a2a85c84b720485f41bbbba6a7084f247b52dd7939b74904142"
    sha256 cellar: :any_skip_relocation, ventura:       "046140357f195dc1cd014f36fabcc0205c20195b13b7b4f95bd15569108b3ac5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e7ce867483c1e3b26f1d242a03ed2888262926d0daf666c194d076bdac97d330"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f747540df3bbd2a75acac7f199c0762a268efaee294922e8a8db0c325bd8c430"
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
