class Fourmolu < Formula
  desc "Formatter for Haskell source code"
  homepage "https://github.com/fourmolu/fourmolu"
  url "https://github.com/fourmolu/fourmolu/archive/v0.14.0.0.tar.gz"
  sha256 "0faa85b5c3e62908164c2e0ecc749bcebda2841b8ca9db9ba16b696f210389e7"
  license "BSD-3-Clause"
  head "https://github.com/fourmolu/fourmolu.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "40c7acd318309abec6599018507bfd6c9301bf7ab3375b08d49b6dca3e69f523"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b007c891a71b98a8252066face2dfa31c7c381549b6e4c35783a7f4d1c5ae908"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "20ed8f934e6c361dceb426a4a6b2382644a83e54474933c9b143b5c93636edf3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "abbb00f2ab04ecf68f055d16931ceab5bf3b0c1beb63d4d63a3cb418c301dd88"
    sha256 cellar: :any_skip_relocation, sonoma:         "9aaf7ff953a933e3f7d372f6e7426fddd70adf6cb98e564ca0245e714b661e5e"
    sha256 cellar: :any_skip_relocation, ventura:        "5b6fac6bb3b70e1e8f4d48dee54895060cda6378f5f4255758259ab509db34ed"
    sha256 cellar: :any_skip_relocation, monterey:       "3506285d5addd8138aee27e0232690eb063b027addb42c819b72e1ac3d483c68"
    sha256 cellar: :any_skip_relocation, big_sur:        "39e3c3b0394806eec9409bd5435bb8967990ea77b9aeb0136e95de47badeebfd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ace9b9f28a3d9ae8b2b17139288e0a33a30e6c9aca5c8a88aa50cd4636b98bbf"
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
