class Pandoc < Formula
  desc "Swiss-army knife of markup format conversion"
  homepage "https://pandoc.org/"
  url "https://github.com/jgm/pandoc/archive/refs/tags/3.1.tar.gz"
  sha256 "c83649ad51ce4479ed6791b1d8578b82312b01d6fba1bbb3294587fa3caf0879"
  license "GPL-2.0-or-later"
  head "https://github.com/jgm/pandoc.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4f8e02800d59dd0f6f48de7ae0a98d741ede640b811fc6d45800b972897fa0af"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2ae3120931b0fb1358190231d6d61d064a2f9215634c9adc0031576a3d3f5f31"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "07b1d919d7392a1fe6608766209fb6d3c9ab5e89c33431520f73ff631f298354"
    sha256 cellar: :any_skip_relocation, ventura:        "1cf2a25ee75032d6f1cfc6b476d0192e7839df6658fae86c38a2d91acb9d670d"
    sha256 cellar: :any_skip_relocation, monterey:       "04bbd41716620cc26be7523fcc4ebad8642001205149cdf85f3a2a917e184fc1"
    sha256 cellar: :any_skip_relocation, big_sur:        "022d52278e2af2dd512f293b00d9505a384a503464f9ea8fe039826f6a05ba8b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f77e0ae266389b46828c4e6cd5cda0e0a8af251cc0b001c2edebea07e1d1118b"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build

  uses_from_macos "unzip" => :build # for cabal install
  uses_from_macos "zlib"

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args, "pandoc-cli"
    generate_completions_from_executable(bin/"pandoc", "--bash-completion",
                                         shells: [:bash], shell_parameter_format: :none)
    man1.install "man/pandoc.1"
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
