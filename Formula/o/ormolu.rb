class Ormolu < Formula
  desc "Formatter for Haskell source code"
  homepage "https://github.com/tweag/ormolu"
  url "https://github.com/tweag/ormolu/archive/refs/tags/0.8.0.2.tar.gz"
  sha256 "40d79a0e2ca0cdb8924d11de4cfdafa253ef82b91baf0b47388d61d749defb98"
  license "BSD-3-Clause"
  head "https://github.com/tweag/ormolu.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "455d08345efdd35bd58fbc526d4fbeaa8591537350e526728340bf5df683e29e"
    sha256 cellar: :any,                 arm64_sequoia: "1217747b904943cb0fe3c5c8925fd1c384df538b1f578defc9d9dbb3458a5a54"
    sha256 cellar: :any,                 arm64_sonoma:  "2ea9791458ca9d85d257a6e6048772303b102ede366a7c58b8cc2d4908ac68c7"
    sha256 cellar: :any,                 sonoma:        "6be2df16ae9c2f99a69a414352b65edf125df8864ca4e0dfba63adde85c5698c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "312a416de29164e83c1fd85910ecf0d3568f27e4f9bdee3b7bde2b0ec103d7bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e633c8de861af86457fb1af18577f7cdadca5fa8ca247e66803d38966c50350e"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "gmp"

  uses_from_macos "libffi"

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", "-f-fixity-th", *std_cabal_v2_args
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
    assert_equal expected, shell_output("#{bin}/ormolu test.hs")
  end
end
