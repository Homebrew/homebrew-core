class Hpack < Formula
  desc "Modern format for Haskell packages"
  homepage "https://github.com/sol/hpack"
  url "https://github.com/sol/hpack/archive/0.34.3.tar.gz"
  sha256 "ca322e3a36852f3aec99969e9ba2f55efba8b6c1538bc1398716833d3b417040"
  license "MIT"
  head "https://github.com/sol/hpack.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "466512c7e107af8fb86a9c9f99d4d7e503a34d619b2a52638f60664bf52fe1eb" => :big_sur
    sha256 "042c0f105b04129a0963bc271af9a834d4ca51c30a228db9977ed89449c36435" => :catalina
    sha256 "a66723dac94a75ca6c70edcfba4446bedad2bbcd66b688bf68e6a3425de75abe" => :mojave
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
