class Pandoc < Formula
  desc "Swiss-army knife of markup format conversion"
  homepage "https://pandoc.org/"
  url "https://github.com/jgm/pandoc/archive/refs/tags/3.1.12.3.tar.gz"
  sha256 "999b119171b92a5f6697d2dec89df49b629506d0f34976a94fdf35e9ae4c5d0d"
  license "GPL-2.0-or-later"
  head "https://github.com/jgm/pandoc.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "92c47fa4aedcb57578d2fea50700ab3b3883c2e43e6cecd707f643ff23153fcf"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6e322095f68b1d85b4fcb1cd9155cd80017540eb3eab7d07193e441095b8813b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eabc09fc5dadbbe2a26586cc4b3544b7381d177c67c18d4d5d65a476f2302fb5"
    sha256 cellar: :any_skip_relocation, sonoma:         "2997d8912753a79a388f9dc7eb87b4fa829192ecc0d1e0c2ebc55f251147835f"
    sha256 cellar: :any_skip_relocation, ventura:        "9e23ce8c62744c62f4e74ce26eb4ebca0b1785cc5f234dfa000fa9ce3da0d859"
    sha256 cellar: :any_skip_relocation, monterey:       "ef606c7458afed2fd9617bcfa581e38f961500ab4c7cb19c4b62648047e7afa0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "56fff1b1855ad6171e7642fac1ab41321f0cbe0b5b9143a462472a743d4db3de"
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
