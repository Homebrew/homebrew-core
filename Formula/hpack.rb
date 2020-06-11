class Hpack < Formula
  desc "Modern format for Haskell packages"
  homepage "https://github.com/sol/hpack"
  url "https://github.com/sol/hpack/archive/0.34.2.tar.gz"
  sha256 "1c23f0a14ca32c92a2b6522d047757850ae89be2b344b19a2df668607f5f72e7"
  head "https://github.com/sol/hpack.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "54170eb908e046af2cb0da4625862a2afed235a61551c78efdb19d7cd6f03ad0" => :catalina
    sha256 "9390fdbbf69427e7935fd4147353e04216c4d61d87f05059ded991040e7cb5f6" => :mojave
    sha256 "c560a84009a6a77cf32a6c60d72e9d297671eadd85e2400d9815473adc80a2d7" => :high_sierra
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
