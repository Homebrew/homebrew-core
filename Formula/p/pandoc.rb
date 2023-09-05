class Pandoc < Formula
  desc "Swiss-army knife of markup format conversion"
  homepage "https://pandoc.org/"
  url "https://github.com/jgm/pandoc/archive/refs/tags/3.1.7.tar.gz"
  sha256 "f0cc7f6ce5a090c2389659a76e88788ae788f175343e01666c37b7e42ac0a9ff"
  license "GPL-2.0-or-later"
  head "https://github.com/jgm/pandoc.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "37bfbb2d799546bc0ab4fa828c3697bfd338c1fde080b4070bdebd907f7ef6a3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6a12b5951e6e914cf506a8db49d0457c67ead9019659c350ec04df4efa5d81e0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f1ea51bef5b8e9214aeed7dc709db084dfec74b43d235e993ae6792c3cd345d7"
    sha256 cellar: :any_skip_relocation, ventura:        "d7da3d26fda6ddae1be1dbade4036e806673e45223026905bec7821367fa466c"
    sha256 cellar: :any_skip_relocation, monterey:       "1441264b6856fe49750f14ba03c977dba45380770e6595d9beec484fdadaa2f5"
    sha256 cellar: :any_skip_relocation, big_sur:        "a4ae512689af43749e87499fe3f97f30109b730598fdf1a686a5e2fc3917ae32"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8ef7ff2f7053e8f60217c2659755ab17016c3319e8bf54e24f4dad52801acb3c"
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
