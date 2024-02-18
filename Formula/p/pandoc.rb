class Pandoc < Formula
  desc "Swiss-army knife of markup format conversion"
  homepage "https://pandoc.org/"
  url "https://github.com/jgm/pandoc/archive/refs/tags/3.1.12.tar.gz"
  sha256 "dafd213a31d2f53a1ec0cd033469834451b1517ff1f1a89fd2223d87e39574fc"
  license "GPL-2.0-or-later"
  head "https://github.com/jgm/pandoc.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3e4faa2e3036de7b7f4cdf8850a5e6b437c5af56d37d6849da17cb855ec834fc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c73d83ff4563c8517042b9784608c3034b4f6de92721a0c6a115f609788c39f2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "79143e0b74e2046d5b63a4d199a9ae55df4874760ffdd060f2cee0bc61cc083a"
    sha256 cellar: :any_skip_relocation, sonoma:         "acfd14876331fe831e66e1f33f89ec9c4a37119ca5472cd9bc4696317cae9ea1"
    sha256 cellar: :any_skip_relocation, ventura:        "b64b75d1fad281e3afa7dc72fb56db8ba807bbbd9010278806af5995daa04513"
    sha256 cellar: :any_skip_relocation, monterey:       "dbd25e519ed3243c8c2cc32ed8ff1773f881270fc222ae3c126b5ca497b8ca02"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "29d3f06d4ac3e28490a615f8ff581275b0c08fdb5266d9e2c36eaf3df8a41829"
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
