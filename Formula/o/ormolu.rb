class Ormolu < Formula
  desc "Formatter for Haskell source code"
  homepage "https://github.com/tweag/ormolu"
  url "https://github.com/tweag/ormolu/archive/refs/tags/0.8.0.0.tar.gz"
  sha256 "e3948bfa80984b70cf0b701b15d206c9010862ea29d44a9a3ebd417646854948"
  license "BSD-3-Clause"
  head "https://github.com/tweag/ormolu.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6cee9b02ace0ce65f8a84cc635178647a8007b1daea9c652573e57399d43e80e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ae68f6fd985883a51bb7f6cfaa98e9a6c44eb247a78e19088e80a2701ed6861d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "84da61972b5d54b7d2a461c0b9a408ca0fdf2856abb1eacd777cd4b7bef69626"
    sha256 cellar: :any_skip_relocation, sonoma:        "ace0cda866c90b4427927a38936d65db91ac1422b62a451b92a31e70a1b34eba"
    sha256 cellar: :any_skip_relocation, ventura:       "c5d8fb13f9d1a8be511e9fd39c62237c0adb65ebc8f7fb373fe8d7d15eab45eb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "870089f99132b6a942b3a35cbf7db091df5487feb0812baabd09a626d1b6260d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "24cdc78d741ef47efd1f3b5ffcd480d538b43f427e7cc381ed09c453118fc01f"
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
