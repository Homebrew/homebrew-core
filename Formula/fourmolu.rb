class Fourmolu < Formula
  desc "Formatter for Haskell source code"
  homepage "https://github.com/fourmolu/fourmolu"
  url "https://github.com/fourmolu/fourmolu/archive/v0.11.0.0.tar.gz"
  sha256 "05b299174cdba289bcf6c3cd6c556130b2dfc7400c20fcc1cf729ad51f8bc74f"
  license "BSD-3-Clause"
  head "https://github.com/fourmolu/fourmolu.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "eb1392bb0eb0895c30096000607250b1a39b2ee24fd182d5dc50fca106d0f9ff"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ac9e4e039e2a3f7e8e4bd0ff0591335ac04efc217dd143dd42aacf03c8df6b1a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "09246881a7687f4c7a541978bb81f9468bc205caff4d1d2087adefe70e603586"
    sha256 cellar: :any_skip_relocation, ventura:        "cf8d31279ace91d6a12d51424e6ec9379612eccad3886c2dbaf025d54b3f9615"
    sha256 cellar: :any_skip_relocation, monterey:       "0002f9638f7da9eaa564a55d4f91511d823ee9bb2d8c296deb9b6bdc413be5a7"
    sha256 cellar: :any_skip_relocation, big_sur:        "32adba286b8a8b3218ecc09b3f34a897c2af0c55bb643a2eae3d5f8c5969040a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6d6da46efb22d0d236cbb3ae6e4a55b3987bcac013d647c4c12297b0635dbbce"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args
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
    assert_equal expected, shell_output("#{bin}/fourmolu test.hs")
  end
end
