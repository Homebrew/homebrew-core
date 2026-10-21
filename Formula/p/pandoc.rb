class Pandoc < Formula
  desc "Swiss-army knife of markup format conversion"
  homepage "https://pandoc.org/"
  url "https://github.com/jgm/pandoc/archive/refs/tags/3.12.1.tar.gz"
  sha256 "cf9b3725b90e471aa70c99ac3b351adcb6e40cd904d36fcbb0f70d712e135686"
  license "GPL-2.0-or-later"
  compatibility_version 9
  head "https://github.com/jgm/pandoc.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "d499933a6ef517ba2096e307ec2364a94ff43b445576c09076caf561420ac765"
    sha256 cellar: :any, arm64_tahoe:       "cb45b113bcb57312e1513a84f295c06ce84b5939ec985742777d5ca1f662f13a"
    sha256 cellar: :any, arm64_sequoia:     "2834d749c26fff94c0a79ce342c8566abbb376d21963652071e44dfe745b7322"
    sha256 cellar: :any, arm64_linux:       "d02af409cc41b65112ee07016a3b809a6751756edc175c789d410ead4f522b56"
    sha256 cellar: :any, x86_64_linux:      "f6fa73a0c40bb3fca16655b5251d910a59141633956d3cc66932ef0c92372019"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "gmp"

  uses_from_macos "unzip" => :build # for cabal install
  uses_from_macos "libffi"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  allow_network_access! :build

  def install
    # Workaround to build aeson with GHC 9.14, https://github.com/haskell/aeson/issues/1155
    args = ["--allow-newer=base,containers,template-haskell"]

    system "cabal", "v2-update"
    system "cabal", "v2-install", *args, *std_cabal_v2_args, "pandoc-cli"
    generate_completions_from_executable(bin/"pandoc", "--bash-completion",
                                         shells: [:bash], shell_parameter_format: :none)
    man1.install "pandoc-cli/man/pandoc.1"
  end

  test do
    input_markdown = <<~MARKDOWN
      # Homebrew

      A package manager for humans. Cats should take a look at Tigerbrew.
    MARKDOWN
    expected_html = <<~HTML
      <h1 id="homebrew">Homebrew</h1>
      <p>A package manager for humans. Cats should take a look at
      Tigerbrew.</p>
    HTML
    assert_equal expected_html, pipe_output("#{bin}/pandoc -f markdown -t html5", input_markdown, 0)
  end
end
