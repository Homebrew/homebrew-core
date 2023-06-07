class Hpack < Formula
  desc "Modern format for Haskell packages"
  homepage "https://github.com/sol/hpack"
  url "https://github.com/sol/hpack/archive/0.35.2.tar.gz"
  sha256 "52417bbfac2de5166f9949c050d02ae2d008975ec4dffa8111cd0c7d31173930"
  license "MIT"
  head "https://github.com/sol/hpack.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d6f7deb996e8ecea13ed2e9c14bacafb095c0783a9cedcbd2dce4e523716bf60"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d4aabeb323f5450462529868df581ea50d42ea3dde63c4aa255a8e7e2665be0d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fe55d80062b95a2de8b22303b15a63f54f7a3d0e3edde411996049b6b00035d9"
    sha256 cellar: :any_skip_relocation, ventura:        "15d8cfd48a2f1a4a18e1dc06924d9e24a32bcaa62c99ab50360d4cf304d73b13"
    sha256 cellar: :any_skip_relocation, monterey:       "077c640f9c974b619b99d842169c674799ceed08957668266df32ba1ece4947b"
    sha256 cellar: :any_skip_relocation, big_sur:        "30920707ce574879a7edad3f9e7a9d561837d0b03467c71c10a74f5413c1befd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "51e4e607f41bd04d3f32aa32aa1cf997bd3b4e83d560f6171176eec23a137e53"
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
