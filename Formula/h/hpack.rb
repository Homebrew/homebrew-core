class Hpack < Formula
  desc "Modern format for Haskell packages"
  homepage "https://github.com/sol/hpack"
  url "https://github.com/sol/hpack/archive/refs/tags/0.38.1.tar.gz"
  sha256 "ccd01b0c737e27bb7c10758fe68fc79c89f0ecf7bfa9c3616938871f0a026ebb"
  license "MIT"
  head "https://github.com/sol/hpack.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "506faf7c344fc1997660ffda25024706c2b54b1e214dbea969aebad5cf0dc111"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7acb9d1da41078cc9c8cbbc99d6d207a70dc84be8969b36289ba959dfceff13b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d0773c8ef24951ae47c9f8857787ddcb1cfe167e3a26f0947cce5fffa25b88ba"
    sha256 cellar: :any_skip_relocation, sonoma:        "fd8894d5c462ad64921917b06d6fb5218498c3449be09efc863f7ef403efb27e"
    sha256 cellar: :any_skip_relocation, ventura:       "e523a9d85f322584f051fe7714f9c83ab58ff17a56deb9ae73526a22f47e7a52"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8ecf79f06c6d22e1e71b63d44c89fec1ba2abff56b1e14d51af04e7ae734a6f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c8c54054592cd045802666c94874a5637edc6745fa94cda90fc3af1b1d97770c"
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
