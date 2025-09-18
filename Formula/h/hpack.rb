class Hpack < Formula
  desc "Modern format for Haskell packages"
  homepage "https://github.com/sol/hpack"
  url "https://github.com/sol/hpack/archive/refs/tags/0.38.2.tar.gz"
  sha256 "cc759633a27cdd5aaa741c37a45cc62b4c63d265cc5bb734d4bb86b2c7cfd5f3"
  license "MIT"
  head "https://github.com/sol/hpack.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "0537c5a947475a73d9e12b748a9303fb0e0472e596ce2b3e0971c6ab7e0decfa"
    sha256 cellar: :any,                 arm64_sequoia: "3384cd197e944d0dd4bdf289d9435b4c82710720f9a1f3575bc58e87a9cf66ed"
    sha256 cellar: :any,                 arm64_sonoma:  "23cdb2e9ef07960f5a60141e1e71d7adcea01cc9ba625477dffe597ec2593031"
    sha256 cellar: :any,                 arm64_ventura: "91b709472b6a94551d833fe6740f3ac65b45d05f6cf0dccc7439bb5ff4f7a6f7"
    sha256 cellar: :any,                 sonoma:        "0f56d0cbf567be266c336d79d23a29648ea73431098f238a58ff16bc71b7ddf7"
    sha256 cellar: :any,                 ventura:       "e292137413a5d053c19ccddc18da1ce517ca2e36ff6648f784fc9d14055b6c10"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c88e6b6ad29cb94737ca20be50349d3eb580b0d67760c52ae3ff81ecea533058"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "acca8343acdd4ee4d27339a80c49378c5c886ce317b3ffb52786b1d7b18c1b35"
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
