class Hpack < Formula
  desc "Modern format for Haskell packages"
  homepage "https://github.com/sol/hpack"
  url "https://hackage.haskell.org/package/hpack-0.39.3/hpack-0.39.3.tar.gz"
  sha256 "75c51500435219f30ef685ef53c91f56c7addeee1eac01c86e96878188f83ab2"
  license "MIT"
  head "https://github.com/sol/hpack.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f3f5948c10791930b1aed31aba527dff2bb7e086cd33303e372569a08c50526b"
    sha256 cellar: :any,                 arm64_sequoia: "2973a038dc0b48304f972f7bbeca5e02f73fe19275d64d580e872456c84a6afa"
    sha256 cellar: :any,                 arm64_sonoma:  "02076f191366ad4ac0f2c608b6b05598f6fdeed51eb7cf6fb884fca665289756"
    sha256 cellar: :any,                 sonoma:        "27634d3c6a9fe105e13a8fcc97b6bf94d277cd8ff97b7b973ed699a33622efa8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3d5886ee0551e5e8ae39476a2e6b81436ef17e39a108950190f56f26a85dbd45"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fe50bbf64a54ba812c21c4437b0e41be51ba935ffeacc976d932d335009af166"
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
