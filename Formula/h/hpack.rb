class Hpack < Formula
  desc "Modern format for Haskell packages"
  homepage "https://github.com/sol/hpack"
  url "https://hackage.haskell.org/package/hpack-0.39.6/hpack-0.39.6.tar.gz"
  sha256 "267459c3961bf66428a1570a71b3aac577c11a07b775b91872282634418ea936"
  license "MIT"
  head "https://github.com/sol/hpack.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "cbeb93984ca220d9a0198fd017f3bf825a4e03939d52b2965f1eaac90047e060"
    sha256 cellar: :any, arm64_sequoia: "548cfd994750ab91c7c4f6671f66b38f1e04b37c6e1e8107777cbe81047e046f"
    sha256 cellar: :any, arm64_sonoma:  "c74bb0f485278329ee7ce5e7e384cb5f72b3499823ccc27664b2f4ca86a2e3fd"
    sha256 cellar: :any, sonoma:        "cc1d838228b244f8fd919a5c6d33114081ec01db1cc2b4448ce68896e8495b7f"
    sha256 cellar: :any, arm64_linux:   "e0ce950252b70b59e9a1dc2c9d86b34f1df707c8ca9d366441042612618b1fb5"
    sha256 cellar: :any, x86_64_linux:  "a3c3008d4b1ad91ce6e9b9b38973236757d83c871d5f9698f266b66a61249c8b"
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
