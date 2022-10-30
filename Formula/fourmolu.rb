class Fourmolu < Formula
  desc "Formatter for Haskell source code"
  homepage "https://github.com/fourmolu/fourmolu"
  url "https://github.com/fourmolu/fourmolu/archive/v0.8.2.0.tar.gz"
  sha256 "b88820eb46890a245e8b5252d62d17642382cbff6b18bc3ff94de31d403490b0"
  license "BSD-3-Clause"
  head "https://github.com/fourmolu/fourmolu.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c27bd969db9b9e2b174fffa891efec3733f6c714d480ba33c4992f19b95d4266"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d6af1bf06d5a732e70d51912a8e4fcd55a021fde537795daac3a59468add2d06"
    sha256 cellar: :any_skip_relocation, monterey:       "25fd33190271e503e3111820fe4ccd850ab61d28ef92eec4255e791f1f8c6f12"
    sha256 cellar: :any_skip_relocation, big_sur:        "b39589657815149376b57e68542b159f043db5af024b49bdbb60c612bf871029"
    sha256 cellar: :any_skip_relocation, catalina:       "396c7644ecabda6ca881f337fe0792d2e83d55e1ed6172a1bb5fe7a72f4d9e7d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1321f4d1ba263ac871ec27412898bdc61515e467e9754c727900cde74044c91f"
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
