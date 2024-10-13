class Hpack < Formula
  desc "Modern format for Haskell packages"
  homepage "https://github.com/sol/hpack"
  url "https://github.com/sol/hpack/archive/refs/tags/0.37.0.tar.gz"
  sha256 "5d292d70744435d67586f9a8a759debbf160cb70a069a8d65403f123fac84091"
  license "MIT"
  head "https://github.com/sol/hpack.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "e23ea1c56e7a987105a80b4c54d14ac248ac89731b13af28c49f8dbba17a51a2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5c9a4675bb72bc2fe3e8335fc830c16a6c56e879d1979acfff71ec995de5eca0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e5d0c25fba0d13f0c209bd62a4645c6a9d580a7f80f75d0d795a6eb51d52f814"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "57e145e9a7bf924201a002e423ae6a137d1e018b8eb3daa18ad42ba43712ac7c"
    sha256 cellar: :any_skip_relocation, sonoma:         "77832296bb8708c4aac8643bd20e5fe2fd0516e543799e1d1ca01b7586a9c1ab"
    sha256 cellar: :any_skip_relocation, ventura:        "b7d2d5abf43bb2f0a489d5b106317fb456a8e88bfee0dbfdebd5378f3bae8ccd"
    sha256 cellar: :any_skip_relocation, monterey:       "7f556437b6cc2b49f48e11d3dc2ba23af7352ca79218b3cfb98cc919c545f861"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "87c5256ee39899b3842e8faf9d9bdbfbdacfbd0cf10e45ec8bea4c6592e248f5"
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

    system bin/"hpack"

    # Skip the first lines because they contain the hpack version number.
    assert_equal expected, (testpath/"homebrew.cabal").read.lines[6..].join
  end
end
