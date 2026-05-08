class Hpack < Formula
  desc "Modern format for Haskell packages"
  homepage "https://github.com/sol/hpack"
  url "https://hackage.haskell.org/package/hpack-0.39.5/hpack-0.39.5.tar.gz"
  sha256 "605e69f2ffe5974bfb6cbc4be203e998389ad79c1590bcf0faafa8d7c085a471"
  license "MIT"
  head "https://github.com/sol/hpack.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "9c63bf51f742f354df756076e4537f0daee440196c447b3a102b8f7d1d96fd4e"
    sha256 cellar: :any,                 arm64_sequoia: "50edbd437691c7a12380dd7e64ed87ee86ab0d422e1cf3718c7efbc29fa68686"
    sha256 cellar: :any,                 arm64_sonoma:  "6ddfd83e7f792ba921aa18571b591ef20052b0837bbc73326057476055246072"
    sha256 cellar: :any,                 sonoma:        "55e7285ac21f468fe254055ddb675da6ba57daeb2ae7de3a51ff53523a40a9e8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "22a17acb78b91a7e969109f14f55b9c645342e8ae1373d045d3a2b12b4bd8f6a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "04939517de7233ba372a0ff33e873474ed832aeaf2ab1e02a415b11f8ef82e5d"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "gmp"

  uses_from_macos "libffi"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    # Workaround to build aeson with GHC 9.14, https://github.com/haskell/aeson/issues/1155
    args = ["--allow-newer=base,containers,template-haskell"]

    system "cabal", "v2-update"
    system "cabal", "v2-install", *args, *std_cabal_v2_args
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
