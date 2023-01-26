class Hpack < Formula
  desc "Modern format for Haskell packages"
  homepage "https://github.com/sol/hpack"
  url "https://github.com/sol/hpack/archive/0.35.2.tar.gz"
  sha256 "52417bbfac2de5166f9949c050d02ae2d008975ec4dffa8111cd0c7d31173930"
  license "MIT"
  head "https://github.com/sol/hpack.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4ca591e1e89109e16c2a40650634ebe2c9d647de04606b5dd6f469ec02d4510f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ebbf54312652e2644272ad186cfa5eeab2a91ad4953125aa07454e7ccc7be426"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1b95cb34787b36f4e6f434bbe7c9085fec2b71e2b7769aff1310f97ad1cf4fa1"
    sha256 cellar: :any_skip_relocation, ventura:        "6abbdd875785449940e77977663d201781f15ce3ba698b9207ee0ea81affb22f"
    sha256 cellar: :any_skip_relocation, monterey:       "ad5f21d29f6e410446ccb36c70a0521edcf629768471bdb44e9509a71f12d81b"
    sha256 cellar: :any_skip_relocation, big_sur:        "15b8b4332d540ebfcd25db66d2d75c7338c642cae7e4ba5c8bff781c74ccb95c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5f16c3fad0e022ff65d4db035433163b0db5c1d9f47f48962c243fea4e7284b3"
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
    (testpath/"package.yaml").write <<~EOS
      name: homebrew
      dependencies: base
      library:
        exposed-modules: Homebrew
    EOS
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

    system "#{bin}/hpack"

    # Skip the first lines because they contain the hpack version number.
    assert_equal expected, (testpath/"homebrew.cabal").read.lines[6..].join
  end
end
