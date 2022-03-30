class Hpack < Formula
  desc "Modern format for Haskell packages"
  homepage "https://github.com/sol/hpack"
  url "https://github.com/sol/hpack/archive/0.34.7.tar.gz"
  sha256 "640c5a235cda86ac85b8bcb2d08f679c493b8f765a7d8bf36445cb200eb8fab8"
  license "MIT"
  head "https://github.com/sol/hpack.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d18bd435a0fe0b891f212320e697f25a35757b51f2ddd581b92b4401ffe213c4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6692c6be0b4c7b1914ee7ec5e83435e38f34d5019414ed7aa64300ad236f150f"
    sha256 cellar: :any_skip_relocation, monterey:       "f45d2e7079d888906b6920c051ed742906dc4ed23c737d7684fced5e951a3832"
    sha256 cellar: :any_skip_relocation, big_sur:        "84332baf3417325603d33b6b31e6b906c038eba223eb331f1b5bcd3909a3b806"
    sha256 cellar: :any_skip_relocation, catalina:       "90a1ac57d94e60b1613494eaa2ec1dea42cd481a41a391958b5c736d515d2812"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ff4d2204baa90231b4940640b00d5b2bfd40518a583f0d108c4117603b1200d5"
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
