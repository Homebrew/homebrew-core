class Hpack < Formula
  desc "Modern format for Haskell packages"
  homepage "https://github.com/sol/hpack"
  url "https://hackage.haskell.org/package/hpack-0.39.6/hpack-0.39.6.tar.gz"
  sha256 "267459c3961bf66428a1570a71b3aac577c11a07b775b91872282634418ea936"
  license "MIT"
  head "https://github.com/sol/hpack.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_tahoe:   "26fd2b22f65fa3a736df0f9fcc7b936f7d609bcd558c510225b5ab6bff5d5022"
    sha256 cellar: :any, arm64_sequoia: "827399fe456b21b25a93e367d4c06339d35ea01df2052f0fa145b12fe1524656"
    sha256 cellar: :any, arm64_sonoma:  "e6dd714a1fa74261687a61dfb0c4a7f9e28c0357fe99c62c62aded9a53034dbc"
    sha256 cellar: :any, sonoma:        "d68cc8dd5761da1fe4d18ecca4e3c47579bb325575a837e74ac46a0deed91a02"
    sha256 cellar: :any, arm64_linux:   "7c76e69f62a536816dcd7b1a9327509a61037b3813faa90866a4b052c9e94249"
    sha256 cellar: :any, x86_64_linux:  "b0cafe774054ceabd1888c225082d1d8321455cbeb016b6100a5f2e45743fa14"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "gmp"

  uses_from_macos "libffi"

  on_linux do
    depends_on "zlib-ng-compat"
  end

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
    expected = <<~CABAL
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
    CABAL

    system bin/"hpack"

    # Skip the first lines because they contain the hpack version number.
    assert_equal expected, (testpath/"homebrew.cabal").read.lines[6..].join
  end
end
