class Fourmolu < Formula
  desc "Formatter for Haskell source code"
  homepage "https://fourmolu.github.io/"
  url "https://hackage.haskell.org/package/fourmolu-0.21.0.0/fourmolu-0.21.0.0.tar.gz"
  sha256 "db321715aa08d24fbf58276dd6f705911d5ced07c00379e9ad10c09aaa064078"
  license "BSD-3-Clause"
  head "https://github.com/fourmolu/fourmolu.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "6c9c0b5a984860433195de96e624f98bbf5898aea01bab14ec3be2d5f85ad8a7"
    sha256 cellar: :any, arm64_tahoe:       "372ed995b99f77202edf4309dbf29abd5398c0f8d916d3135f6efb53b263eb4e"
    sha256 cellar: :any, arm64_sequoia:     "a445de12f555689febce22828d26401c1ed6d611fc1555a216f2e071f0930df2"
    sha256 cellar: :any, arm64_linux:       "8f2fc5ca1c0187aac0d85e4bd64db8b670aa0c59ef6bcb722195f5bdf4ab4605"
    sha256 cellar: :any, x86_64_linux:      "4bdac27d3f5bbb9796aade0547174e95d3dde92beb92007e262b36741d360cd5"
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
