class Pandoc < Formula
  desc "Swiss-army knife of markup format conversion"
  homepage "https://pandoc.org/"
  url "https://github.com/jgm/pandoc/archive/refs/tags/3.3.tar.gz"
  sha256 "7025e32e9cce7cbde9f43afedbf34f16b37fd71b96626752fd18425ae67baef7"
  license "GPL-2.0-or-later"
  head "https://github.com/jgm/pandoc.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4d2d723abab4cbe54eb9bcc30bde8412c58b708203833dd32cf79c4c9aa2e830"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "68e33efb596ef5dc6ffea7326c0772ac975e01871fd904231cacb5a0fb20843b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "825acbda6041526458b7004ed7d712a7c08534b75d3bf60992d951b9af360473"
    sha256 cellar: :any_skip_relocation, sonoma:         "eea2768ec327af33c47b4a2c30a6cc025ad0d0ab3c3a07c396632129e8883ad6"
    sha256 cellar: :any_skip_relocation, ventura:        "7a387350b73838bcdd9cee1c91bb81739fa8e74839e639128845bd8fcb316889"
    sha256 cellar: :any_skip_relocation, monterey:       "637e5e99b56af6608247c65990be24c1b9870a642ce3a451ba2470051d2de813"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2875eaebe531bedcdc73d576047e855708ee380c1302519a3661cc7647596d4f"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc@9.8" => :build

  uses_from_macos "unzip" => :build # for cabal install
  uses_from_macos "zlib"

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args, "pandoc-cli"
    generate_completions_from_executable(bin/"pandoc", "--bash-completion",
                                         shells: [:bash], shell_parameter_format: :none)
    man1.install "pandoc-cli/man/pandoc.1"
  end

  test do
    input_markdown = <<~EOS
      # Homebrew

      A package manager for humans. Cats should take a look at Tigerbrew.
    EOS
    expected_html = <<~EOS
      <h1 id="homebrew">Homebrew</h1>
      <p>A package manager for humans. Cats should take a look at
      Tigerbrew.</p>
    EOS
    assert_equal expected_html, pipe_output("#{bin}/pandoc -f markdown -t html5", input_markdown)
  end
end
