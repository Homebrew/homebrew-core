class Hpack < Formula
  desc "Modern format for Haskell packages"
  homepage "https://github.com/sol/hpack"
  url "https://github.com/sol/hpack/archive/refs/tags/0.39.1.tar.gz"
  sha256 "87f89f175b20ad436aa913d711a1e8eea202c7fc6a534e14ca3b7a2f033c1c30"
  license "MIT"
  head "https://github.com/sol/hpack.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "bccf8f0adae2c470ff2ac8b2b98362bd65cbbfb8cc835ee5f0661e44a00a3548"
    sha256 cellar: :any,                 arm64_sequoia: "82876a19870c2d5538d376f31e194c7d9f6db186179f167b30722741a7acce20"
    sha256 cellar: :any,                 arm64_sonoma:  "93de19b5e801f7bdb155254d944045a3a7d48485a204bbc39047b3cad714183a"
    sha256 cellar: :any,                 sonoma:        "171f27403ad5d8f29522b99026b6226fb7af8dd3fbcbd0ac6717a252f03db809"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6e95f26e8e08693ceefb0050369b516cf46cc433f40413914ccb7ff3a6b7dcb1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "de4b1cb3ecb015a26134b8520dfe06b10898124315d1461750f7447e91b65c3b"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "gmp"

  uses_from_macos "libffi"
  uses_from_macos "zlib"

  def install
    # Workaround to build aeson with GHC 9.14, https://github.com/haskell/aeson/issues/1155
    args = ["--allow-newer=base,containers,template-haskell"]

    system "cabal", "v2-update"
    system "cabal", "v2-install", *args, *std_cabal_v2_args
  end

  # Testing hpack is complicated by the fact that it is not guaranteed
  # to produce the exact same output for every version.  Hopefully
  # keeping this test maintained will not require too much churn, but
  # be aware that failures here can probably be fixed by tweaking the
  # expected output a bit.
  test do
    (testpath/"package.yaml").write <<~YAML
      name: homebrew
      dependencies: base
      library:
        exposed-modules: Homebrew
    YAML
    expected = <<~EOS
      name:           homebrew
      version:        0.0.0
      build-type:     Simple

      library
        exposed-modules:
            Homebrew
        other-modules:
            Paths_homebrew
        build-depends:
            base
        default-language: Haskell2010
    EOS

    system bin/"hpack"

    # Skip the first lines because they contain the hpack version number.
    assert_equal expected, (testpath/"homebrew.cabal").read.lines[6..].join
  end
end
