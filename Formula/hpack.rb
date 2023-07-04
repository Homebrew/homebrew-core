class Hpack < Formula
  desc "Modern format for Haskell packages"
  homepage "https://github.com/sol/hpack"
  url "https://github.com/sol/hpack/archive/0.35.3.tar.gz"
  sha256 "8b8b0df5a2db1c0b1a4219876868e6a66bec382647c37fa78da922090aa7a227"
  license "MIT"
  head "https://github.com/sol/hpack.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d81f794e8730a80629948005fc985b01847da13297ce5b23b123bfa4fc59b9ce"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0c746217d349a82f42d23383a1bfae0434ee3f2439c0817a551d497810c9b7c4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "12438c63484f81d9805b23eeb16fc82c386540904b748b43537deded6593936d"
    sha256 cellar: :any_skip_relocation, ventura:        "abae0a154914ee76d8af87a7a7286a44d04d5c29ce608ed543d2788328a0144d"
    sha256 cellar: :any_skip_relocation, monterey:       "52b3371fbf389889306fff7efb738167fbce2396e59544edf460286223bd28f2"
    sha256 cellar: :any_skip_relocation, big_sur:        "f2f056f2d451b394d2bc334ec01d885bc4b6e8372454108f439e3df71dfe199e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dacefe1df0ca943d96aa0931518ded77bbf793a918ee70db845dc3591a1b5909"
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
