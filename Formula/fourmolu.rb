class Fourmolu < Formula
  desc "Formatter for Haskell source code"
  homepage "https://github.com/fourmolu/fourmolu"
  url "https://github.com/fourmolu/fourmolu/archive/v0.13.0.0.tar.gz"
  sha256 "e519db0a934a2789c3bf31f6853bb55f2d703ee29ee4bbe0bd86000498ccb393"
  license "BSD-3-Clause"
  head "https://github.com/fourmolu/fourmolu.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f2c675ac5a91e383852c8996abfeaf31833120700d528556cb58db0cd00eff79"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0c6468b652e8d7ed0ba366f33b56cf717dbd0c2d4a3bd5568ff9a62cb663d8b4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ff0689552b081010f166369394e0d8933b895be85caaccc2dc742c848bc00897"
    sha256 cellar: :any_skip_relocation, ventura:        "8a3feba26b466055355aa32de757fdb45fbbbbb320ba75c4778bd0c906310085"
    sha256 cellar: :any_skip_relocation, monterey:       "4e148b5855f08e3a883301ffe77d211d8e09dce09cebf2b3ef334a508a59ae5b"
    sha256 cellar: :any_skip_relocation, big_sur:        "6a8fa92c5a5f71b6714ca1febdbd2f4d5d5c1dfa010e071670a1820aed0e32ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "70422aa62d58a395b204e4ea342da181d990b0de9daf97d3d5ce0636ec1b683c"
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
