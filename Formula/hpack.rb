class Hpack < Formula
  desc "Modern format for Haskell packages"
  homepage "https://github.com/sol/hpack"
  url "https://github.com/sol/hpack/archive/0.34.2.tar.gz"
  sha256 "1c23f0a14ca32c92a2b6522d047757850ae89be2b344b19a2df668607f5f72e7"
  license "MIT"
  head "https://github.com/sol/hpack.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "e230f0684178727141cfb242d235de3f062a056816c06c1e882ad3c2caf34c35" => :catalina
    sha256 "cc6b80c259ea44fdb961fc758c9472264b48ce481f5c9d436c325493d7d13c0a" => :mojave
    sha256 "197fe924cebba40e09bf85adb60beeb889e576cc8600b1e92361f20a5e9c0a04" => :high_sierra
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build

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
