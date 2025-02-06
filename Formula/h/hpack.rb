class Hpack < Formula
  desc "Modern format for Haskell packages"
  homepage "https://github.com/sol/hpack"
  url "https://github.com/sol/hpack/archive/refs/tags/0.38.0.tar.gz"
  sha256 "2bd41314b87e4cff9bfec7ac327f8f0bf8b2b6461c209a3241629aeeb05111a3"
  license "MIT"
  head "https://github.com/sol/hpack.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fee14b444f7879ac1c82fcb7eb00914f56c3ed451272cceec2e09dbe598995ea"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "83c35465ecc6b8b340d5df6a100403dd00a4dcf86e4be9e353c9f22f1522b0f2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "99a3c126854d781ec4f5744cef4c069f80688781b7e399d7b3a07d23fbacaf3c"
    sha256 cellar: :any_skip_relocation, sonoma:        "2200458de6722f4566382ca01fa69be6005ad6d462dd47dda24ef1a1af45e6d3"
    sha256 cellar: :any_skip_relocation, ventura:       "c1eecf23e948de0da278bb02d1477870c68139c26980402fc8a041e26271dc7d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5e7dcdd7b3acc57d6785a9b71e417df3a345d31a670d57140c00f25d9f9f8c01"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build

  uses_from_macos "zlib"

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args
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
