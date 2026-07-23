class Fourmolu < Formula
  desc "Formatter for Haskell source code"
  homepage "https://fourmolu.github.io/"
  url "https://hackage.haskell.org/package/fourmolu-0.20.0.0/fourmolu-0.20.0.0.tar.gz"
  sha256 "34a3cedc64042e4f36bf7a94bae1e11d43a1571933ceb96e5d838447b3bd17b9"
  license "BSD-3-Clause"
  head "https://github.com/fourmolu/fourmolu.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_tahoe:   "fc2ba2828fb37dfc189563e3a7eef611c902acd57e1d3594edf84da0f56f8f1b"
    sha256 cellar: :any, arm64_sequoia: "a356495ec02e98ae14882106c8f0de59b3718e338ace7d30404080c7f0f8544a"
    sha256 cellar: :any, arm64_sonoma:  "4edaa8586ee58fe0ad39639546a95ed7d4a48bddf9d3fb9f8c0a76b36adb94b7"
    sha256 cellar: :any, sonoma:        "776ac9f97d730989a3d6ab573a971ab9bb4c27d85d73e399806a89b989ae794f"
    sha256 cellar: :any, arm64_linux:   "189169e33bfda138d8ab2df06b321b4d873e23783e3f6e97e14ea8e82c44446e"
    sha256 cellar: :any, x86_64_linux:  "932a8c1416f2d14e1b9c4fa30b4988566306be44f08fd6e4164dd3af7c039a43"
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
