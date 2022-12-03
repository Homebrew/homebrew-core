class Fourmolu < Formula
  desc "Formatter for Haskell source code"
  homepage "https://github.com/fourmolu/fourmolu"
  url "https://github.com/fourmolu/fourmolu/archive/v0.10.0.0.tar.gz"
  sha256 "e0daa1cd173fa18aa248bc181c50be1ffd7b869388e075d029a671fe9b48745f"
  license "BSD-3-Clause"
  head "https://github.com/fourmolu/fourmolu.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f2ae13d31c1cd0c98ab160d6ab4633a8c28751b48f168d177c96214db10a4906"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c75fb4de2f8cfeacc01367622619da8529292cacf2fc6bd06e87078a780b4293"
    sha256 cellar: :any_skip_relocation, ventura:        "71066dad01725d5bc98e4a69890154dbb8a4df69ce44db6aa2ddaab32de39aa4"
    sha256 cellar: :any_skip_relocation, monterey:       "b3a971604e918f251eb1b5a973d5c0311a580967eea8035a2068c9c2fb52b66d"
    sha256 cellar: :any_skip_relocation, big_sur:        "d0ce723afff7d3acbb2be08136131df89c81018f6310555f349962609aff58da"
    sha256 cellar: :any_skip_relocation, catalina:       "eedc285ac8fce49c697256e2f1bf825c4e4169a91fe3ed32ece792f83ecb8469"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3c3d27a4d7cb63f18764d771ca9c09f316b6bde8cec6f9e8d33f9fd8663397e8"
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
