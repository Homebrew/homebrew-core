class Ormolu < Formula
  desc "Formatter for Haskell source code"
  homepage "https://github.com/tweag/ormolu"
  url "https://github.com/tweag/ormolu/archive/0.7.1.0.tar.gz"
  sha256 "1acfd517930a8bd57d4362c2f7a72d308fa35e8580787352fd53601249345934"
  license "BSD-3-Clause"
  head "https://github.com/tweag/ormolu.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a3e96790979fc0009694a27dc78f48eadf6ec433e66bf0d629073958a3872e6d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b3af6fbee8eb58dbe46da471dea0c1e52ef30b40897332b5c274ca829dcd5ae0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a0e25823bfdd9fa45ad0d9563cf881e01dd08f4cfc382330b62f87a2715a86d3"
    sha256 cellar: :any_skip_relocation, ventura:        "7519bbf8e7fa4a63db733fec3bfc5531c3a4797526d19da8fd05550fe0c694ab"
    sha256 cellar: :any_skip_relocation, monterey:       "1b4d9e60eb5be7a3e29cbad312567a967aa37075f14b945712072280e0017c91"
    sha256 cellar: :any_skip_relocation, big_sur:        "d2a8f5a7343c43099c99644493c71783494cdc37621b18c18259d24b8e2392e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "19738fdad76b187cad3d628f8d5f56b0aea5b50c1c594dd92112484f4fffdab4"
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
