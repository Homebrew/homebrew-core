class Ormolu < Formula
  desc "Formatter for Haskell source code"
  homepage "https://github.com/tweag/ormolu"
  url "https://github.com/tweag/ormolu/archive/0.6.0.0.tar.gz"
  sha256 "953c4995df6dab14aea49680b843b8b0d741ffea942b4221ed2168a5a9147ed6"
  license "BSD-3-Clause"
  head "https://github.com/tweag/ormolu.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "74beeb33ed0e0fcbb36864850887330273e9cf89a00e726b2f06646673f01942"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "934f8e574a120ceecaf0f3793b71da59ec28e6dc4ca79a601a2367d9472ecd47"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1a67aed9bd52c59593f91d25b24192590afcae0e46db612608a633e49514bbfb"
    sha256 cellar: :any_skip_relocation, ventura:        "0f1ac57fd4c26017526da656da06de8b2b5726ffd6c1dc9968a617a62089c181"
    sha256 cellar: :any_skip_relocation, monterey:       "f5451a4997bb0a026e5657d78d4901a2d8189f23e645fa5a2ca23c7230e1bd4f"
    sha256 cellar: :any_skip_relocation, big_sur:        "f3cd87e9f56c53736f738ef12510670df67cafffbc27a4c266d72cd30b04d112"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4216c53ba948f1992a1171e6d10e13074f5e485502b710b995f407e03fda855d"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", "-f-fixity-th", *std_cabal_v2_args
  end

  test do
    (testpath/"test.hs").write <<~EOS
      foo =
        f1
        p1
        p2 p3

      foo' =
        f2 p1
        p2
        p3

      foo'' =
        f3 p1 p2
        p3
    EOS
    expected = <<~EOS
      foo =
        f1
          p1
          p2
          p3

      foo' =
        f2
          p1
          p2
          p3

      foo'' =
        f3
          p1
          p2
          p3
    EOS
    assert_equal expected, shell_output("#{bin}/ormolu test.hs")
  end
end
