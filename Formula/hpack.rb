class Hpack < Formula
  desc "Modern format for Haskell packages"
  homepage "https://github.com/sol/hpack"
  url "https://github.com/sol/hpack/archive/0.34.7.tar.gz"
  sha256 "640c5a235cda86ac85b8bcb2d08f679c493b8f765a7d8bf36445cb200eb8fab8"
  license "MIT"
  head "https://github.com/sol/hpack.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4547d44abc0430152312179e3add1b5992177a5370b4c464d7111b60c455064b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "262e9631bc059b760ebaf90d9c19d2d5b7ca08c545775a8bebdf9f72ff121ea9"
    sha256 cellar: :any_skip_relocation, monterey:       "eb09a7631dfd336c6c413594d147e9b9256786e6dd95527f0dc6f72b230e1d1f"
    sha256 cellar: :any_skip_relocation, big_sur:        "6d25241104086d39f58c6b57af690d88e5b50d6427528eaef58f2955d910b6c3"
    sha256 cellar: :any_skip_relocation, catalina:       "7b5badf2e34c119540f82194c1fd55bf85a67af7f48083d2a839af86cde740db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3057ec78424d592bcb1a3e9173a119573ab6648187f50ffea9b7370dd1e80d7e"
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
