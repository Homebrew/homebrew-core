class Pandoc < Formula
  desc "Swiss-army knife of markup format conversion"
  homepage "https://pandoc.org/"
  url "https://github.com/jgm/pandoc/archive/refs/tags/3.1.12.1.tar.gz"
  sha256 "2df4b708480486ade33e29aa4ea99be7bb23198596d96ececc2867c7e50e1ba7"
  license "GPL-2.0-or-later"
  head "https://github.com/jgm/pandoc.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4c6e5c5df2b1018d7fd37a52855d12d2946eb78e06bb55ab4a0df9c723bf1842"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a34e54bc8d82e0715d48a5df9d55f82f0639962769648a077ce3343397626062"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2ee46a0da294cd3db5c3f390a335ca5358527c56e1b48686079e4b79c9d95019"
    sha256 cellar: :any_skip_relocation, sonoma:         "bc90e8fdb77bb25ca170146576102ca2ffd1e6aee34d6e149ec02556fa925222"
    sha256 cellar: :any_skip_relocation, ventura:        "a4223f8d9c7339c6b9d5cdf660eb3be757350d52e1a41a9d788a7c1710b52378"
    sha256 cellar: :any_skip_relocation, monterey:       "f0158266a50de37ae02922c446cfc6f6710b58f8bd0d986aa866144124c2fade"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8efbd1f5bfea0c4603f81aa6edb7d3a9f4165c303b6a6ab301addfc85eb15116"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc@9.6" => :build

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
