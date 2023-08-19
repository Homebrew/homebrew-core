class Hpack < Formula
  desc "Modern format for Haskell packages"
  homepage "https://github.com/sol/hpack"
  url "https://github.com/sol/hpack/archive/0.35.4.tar.gz"
  sha256 "d0c1aa8031bacc9ef1dd01279a29616323bd9f1486e81585ed7fb7eccbb36451"
  license "MIT"
  head "https://github.com/sol/hpack.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "391ad2e831349bd03911ad37acaf59fb174bcd87e44261e73cc0725b5317b544"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "af1a2a57ba3f3235340731d08d4611b0ea2883f848e331f502ff28e0dff3ce9a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "264415d70b5514820a0929e425af279d86e88e8e3006435cbcf2522d03ff7d45"
    sha256 cellar: :any_skip_relocation, ventura:        "0aa86cda58440a1bb7075dfbb676a97973e85f66cf90c323efc3a5d3944a52ca"
    sha256 cellar: :any_skip_relocation, monterey:       "ea5b8e97988cafaa5a78e08bfb3eb31703bbce66a75905164af582c2a12f85b6"
    sha256 cellar: :any_skip_relocation, big_sur:        "d716d26cba15a166bdc56a915f94c3a546ff08ca1a49991d3a834f6a3f402540"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6a1d6edb658bd53a39b16dd2baf35e71bfa4f2f5addc2387b3ea1ca7807cbb09"
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
