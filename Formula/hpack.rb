class Hpack < Formula
  desc "Modern format for Haskell packages"
  homepage "https://github.com/sol/hpack"
  url "https://github.com/sol/hpack/archive/0.34.4.tar.gz"
  sha256 "65862a5ebef8efe236d44ea54229742766d26fe1e39220b7b98f3486cc0adcaa"
  license "MIT"
  head "https://github.com/sol/hpack.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "e8189942eff2e520bd69abbab6952def3781d2cee4c98e1d97f27cc14e362241"
    sha256 cellar: :any_skip_relocation, big_sur:       "a2e901e85d547afaead51bf4d2c33d27033c74e2eeb4e6eca418339e4782e3e6"
    sha256 cellar: :any_skip_relocation, catalina:      "0368b8c4ab5eef0197b563c10852bcd8ab6456d59d6c9e34f48e36e0400803f6"
    sha256 cellar: :any_skip_relocation, mojave:        "5ebb44b4700c69ba46807cad1a04d43db91f87246818611403dcd7963762ef1d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5930fc9ba975f18ba0db9bcbf1258a18c602c547c955db693e85e0bc4ac83178"
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
