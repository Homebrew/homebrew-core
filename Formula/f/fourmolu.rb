class Fourmolu < Formula
  desc "Formatter for Haskell source code"
  homepage "https://github.com/fourmolu/fourmolu"
  url "https://github.com/fourmolu/fourmolu/archive/refs/tags/v0.19.0.1.tar.gz"
  sha256 "815bdcd38ee87823d421be42cb5add06d7ee6507e746a40b0df720fdd6c8a8dd"
  license "BSD-3-Clause"
  head "https://github.com/fourmolu/fourmolu.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "27d7f072d6628f3d209134278bea538caaed202d84f64179bc0f36b34916489c"
    sha256 cellar: :any,                 arm64_sequoia: "5eb6b8b769a6e7474f437fc138c5ee83c8f47063b0e1dca017cae628c0a78ba7"
    sha256 cellar: :any,                 arm64_sonoma:  "5514f5d8b1c487d4c6a91cd5d03adfbb80035b8441b53af7b1935f10e67e9e5f"
    sha256 cellar: :any,                 sonoma:        "74be792a2b287d7cecd14f6573a015744bc54aa3a90e2932509a3ccf8a8346fb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7781851b29b380175699e0985fada369c6d693ed5ca576ee39a9f425f60fd913"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6c33d9448da66ef7ef6b2336442fb7b925ea62dbbec8713cd337040f27bc0ba6"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "gmp"

  uses_from_macos "libffi"

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args
  end

  test do
    (testpath/"test.hs").write <<~HASKELL
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
    HASKELL
    expected = <<~HASKELL
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
    HASKELL
    assert_equal expected, shell_output("#{bin}/fourmolu test.hs")
  end
end
