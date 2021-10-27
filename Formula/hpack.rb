class Hpack < Formula
  desc "Modern format for Haskell packages"
  homepage "https://github.com/sol/hpack"
  url "https://github.com/sol/hpack/archive/0.34.5.tar.gz"
  sha256 "351ca33e14599602961d4061fff45b7893d1ea7eafc55c10d298445cd2f34ca0"
  license "MIT"
  head "https://github.com/sol/hpack.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "60566418c082e7da4478563a456375b5b40695a2311379109ab7d21f75434da1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9c1aaf762db8ae437de6483a6614925c1ca4412df71b220aef4d54afb0d9f1b4"
    sha256 cellar: :any_skip_relocation, monterey:       "2652dc9b4e38d165f8051942807dc5da9cdd5b7b6c325cd99dcc023cb0aacbcb"
    sha256 cellar: :any_skip_relocation, big_sur:        "807f4c5ce6363b4051ae08c4a00089fd91c4bb7cab4e3247af0e9cd8c22ece37"
    sha256 cellar: :any_skip_relocation, catalina:       "9fbf23b07e7d3b61ff29a3c95f487456584db41011f3258a3b2ee3305b9f79a9"
    sha256 cellar: :any_skip_relocation, mojave:         "09ee5036e2bae87c171460857ed5fbb0abf83d4f3dee6605c1e3df7464aa02e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aac2909793335d9b37761f540fa49816d9613f0ebf94eb740bb2a7211f5f8220"
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
