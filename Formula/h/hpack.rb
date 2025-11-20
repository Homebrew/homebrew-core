class Hpack < Formula
  desc "Modern format for Haskell packages"
  homepage "https://github.com/sol/hpack"
  url "https://github.com/sol/hpack/archive/refs/tags/0.38.3.tar.gz"
  sha256 "08550020ec987490d540a8a5004699d4b59518a84813c2fd96f3000d86ee2c94"
  license "MIT"
  head "https://github.com/sol/hpack.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "4610e7c7e848f7750560fcd7067bb5ee7f05ed97d00a050348258e5cfa876804"
    sha256 cellar: :any,                 arm64_sequoia: "603c42ec65506814584695a562db76dcfda87dfaecc8fabbe3a62ec38c26660b"
    sha256 cellar: :any,                 arm64_sonoma:  "1febba455f551d9dc4799a0697f1a52993d9bb934ae3a7ef415f97188bccfbd5"
    sha256 cellar: :any,                 sonoma:        "13d9e33f4146812e955c8b302ca12898f8f0e9a29c8ab4ffb7458e4c761dc4d5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ef2a230d313d0c05cc9e4bb7dd5ac7710c3fa681c215ffbf6d5d4788becc1599"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "45214110f26cc914b5463e5b4ca150defdd83807e82c7e74343fb05c8f3be599"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "gmp"

  uses_from_macos "libffi"
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
