require "language/haskell"

class Hpack < Formula
  include Language::Haskell::Cabal

  desc "Modern format for Haskell packages"
  homepage "https://github.com/sol/hpack"
  url "https://github.com/sol/hpack/archive/0.33.0.tar.gz"
  sha256 "954b02fd01ee3e1bc5fddff7ec625839ee4b64bef51efa02306fbcf33008081e"
  head "https://github.com/sol/hpack.git"

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build

  def install
    install_cabal_package
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
    assert_equal expected, (testpath/"homebrew.cabal").read.lines[8..-1].join
  end
end
