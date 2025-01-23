class Fourmolu < Formula
  desc "Formatter for Haskell source code"
  homepage "https://github.com/fourmolu/fourmolu"
  url "https://github.com/fourmolu/fourmolu/archive/refs/tags/v0.17.0.0.tar.gz"
  sha256 "c5cfe76b98af560fc54babd70f6dfb959c549b09a7977501f19d7b6a8a9495b5"
  license "BSD-3-Clause"
  head "https://github.com/fourmolu/fourmolu.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "da004206b9e1c479df9eb07e28dcd5015447ce85803f397bed3e5006ca5f035d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ce05e148ee0c80b26a1c930cd8b195cc6d945e45906362e18a711b562eb68e62"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e2e8bb30ae6b1965e3b592de62ce3b40ddeda9f9723eda1431591cbf26fd33f7"
    sha256 cellar: :any_skip_relocation, sonoma:        "2c3d1bc872da2ea5437421b3ec9c7779a11a52320694a6bd413b91bb41c7dd99"
    sha256 cellar: :any_skip_relocation, ventura:       "68a74fa1508256b9d75064a1f15ce254d3239653ba900eddc5b4d02702b32c3f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dd1cc0e6f2d10794b22bd1bea61900a9972426ff5e41079e2ac6ce6559d1dc35"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc@9.10" => :build

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
