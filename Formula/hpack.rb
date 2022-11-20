class Hpack < Formula
  desc "Modern format for Haskell packages"
  homepage "https://github.com/sol/hpack"
  url "https://github.com/sol/hpack/archive/0.35.0.tar.gz"
  sha256 "5f92885b3609b87f499a5e8840c092aa76d8196275ef4abf68fa54e35f80ace1"
  license "MIT"
  head "https://github.com/sol/hpack.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5a3a2a22f4ec0040e49ea3c9f0cee6b0aa9088626b145c01db092364f951b87a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "151c61eb08afd855006104db4ad884225afa63b562ef1b5261986c5ad67b85fd"
    sha256 cellar: :any_skip_relocation, ventura:        "5c1891ae0a2c5fbbb3a41007cf1b4d08915af6470bf812178fe9f448daf47001"
    sha256 cellar: :any_skip_relocation, monterey:       "b2ca3c047995f49715b8a9f5f7b8e18611d33699b9d910fe3f2c39955bf01be7"
    sha256 cellar: :any_skip_relocation, big_sur:        "9d3a127911fe1c275e37351611d5d8b35bf6009b6006c9df9a163072ee8d1c3c"
    sha256 cellar: :any_skip_relocation, catalina:       "35be3997828e2752693e8f02b80bfd918f3e9d3707364e8aa0f5db552504a104"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "758f4e3ebcfc75ff2d7a74c9c8a52d55664583e1286f15299cd8777f460be012"
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
