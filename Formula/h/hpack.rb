class Hpack < Formula
  desc "Modern format for Haskell packages"
  homepage "https://github.com/sol/hpack"
  url "https://github.com/sol/hpack/archive/refs/tags/0.36.0.tar.gz"
  sha256 "f9b903b040d6736335fc2210c9243b0f18c41f52b7da2560a700ba6d8648bd77"
  license "MIT"
  head "https://github.com/sol/hpack.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cd6577e594dd7884e7180d1c1ae35c52c4f1817e0502d3db5d055a28e4d81221"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c3c6c86f8c69d05d398b67f519dcffddf176710bcb26245ef6133f621724d748"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4a35250a53a92907675395adac052a3746143e44907bf1ef1139d2c6cb9f12d8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "efb26df571e245ac808bc8223a0922b9b3b21698af7e96b9495dbb1bec3f1bac"
    sha256 cellar: :any_skip_relocation, sonoma:         "19098f168af3ff78083d72bdc9d353697ef3d04bdc348c35dcba99984f8cd699"
    sha256 cellar: :any_skip_relocation, ventura:        "2dc6b0594b45dccc62034c59eafe73f4cd19f19c175c2134b0aba58ee65d3645"
    sha256 cellar: :any_skip_relocation, monterey:       "dab4df2eb5b914455a9809b82a986083259ecd62cc208d4f06edadc474a09044"
    sha256 cellar: :any_skip_relocation, big_sur:        "f46c67af38ca32fc51c6cf8e07dc42fd5eb4208a85d5855b559290a22d7081f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "69e9bb29b6200ed0d609387e37e0dc3e8eaf21e741f415a34310b15e4d1e89e0"
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
