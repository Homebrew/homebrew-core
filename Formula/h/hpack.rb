class Hpack < Formula
  desc "Modern format for Haskell packages"
  homepage "https://github.com/sol/hpack"
  url "https://github.com/sol/hpack/archive/refs/tags/0.39.0.tar.gz"
  sha256 "b35458a9455089254edd2ff39a4daeece67eb6ae2bd64eee4dbcb56e04b746e2"
  license "MIT"
  head "https://github.com/sol/hpack.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "9bc78835cfdce33ad2080c9cb18985ac6a291c0234b2794dc3676e793dbe7601"
    sha256 cellar: :any,                 arm64_sequoia: "49309f5cd7a10b04b4f0bca4f57b94b7ba7139c83ffe559eb3019c72976a272f"
    sha256 cellar: :any,                 arm64_sonoma:  "3d8f9fdfdc5f7f0ce856a5e55f1338ab6111fcf8188159264194fb538016a4d0"
    sha256 cellar: :any,                 sonoma:        "c95260f5ca17a322f2eade6698aab11fc403bf1b0fc4632db143f64097efe680"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a3e1adb3cb429417979068847305794d065f53d98ecb43f491e92b9ec3196be1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "abbc5cff6006b00b7184213e562d25d542db81183f4e26b6ef9942a60ed377a3"
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
