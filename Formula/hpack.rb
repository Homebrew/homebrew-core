class Hpack < Formula
  desc "Modern format for Haskell packages"
  homepage "https://github.com/sol/hpack"
  url "https://github.com/sol/hpack/archive/0.33.0.tar.gz"
  sha256 "954b02fd01ee3e1bc5fddff7ec625839ee4b64bef51efa02306fbcf33008081e"
  head "https://github.com/sol/hpack.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "07e202936d3d52f9a70975d879115876b667daf26af468500c5117e1c235aedd" => :catalina
    sha256 "43ce8ac6c6f0b1642b3912c875f3c1f47732994411beae48819aa105bd97a55e" => :mojave
    sha256 "f4de8c3939a1fbc917740d0694dc729619f706962d7015af9f931d7291c952bd" => :high_sierra
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
    assert_equal expected, (testpath/"homebrew.cabal").read.lines[8..-1].join
  end
end
