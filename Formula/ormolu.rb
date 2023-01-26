class Ormolu < Formula
  desc "Formatter for Haskell source code"
  homepage "https://github.com/tweag/ormolu"
  url "https://github.com/tweag/ormolu/archive/0.5.3.0.tar.gz"
  sha256 "3f40ab134489482d4a7ff816089dc6c793649bfa776e2e1105b3c887711d6a73"
  license "BSD-3-Clause"
  head "https://github.com/tweag/ormolu.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3ccd511ee1f6dd0c109cbc23b220ae40c34ec3fe741d87b16f3c5ebb380f1096"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "63f9019dea5ddb76023b63858dce71f6f6aaf83fd2303999406c68d0634d9c24"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e9964b8f2959e7575ff1e285978f281791d9349c3174705552b4a20921cdb183"
    sha256 cellar: :any_skip_relocation, ventura:        "31f026a54449ad3f75ca9a0bc6a612f788f879f56e8945dc03af479f9bbb2b17"
    sha256 cellar: :any_skip_relocation, monterey:       "742040c131720996e88493607bb8e8ec1fe030fa9ba658f251f08c2575bde97c"
    sha256 cellar: :any_skip_relocation, big_sur:        "5da442920789235b882bfd863d6d064cf055a45a74a0e9a5d1be652f7ee8ba48"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "759031e1e50ce8df637eba0c82ac674516b30650d41042c6167e7607cea6844d"
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
