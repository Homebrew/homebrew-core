class Hadolint < Formula
  desc "Smarter Dockerfile linter to validate best practices"
  homepage "https://github.com/hadolint/hadolint"
  url "https://github.com/hadolint/hadolint/archive/v2.6.1.tar.gz"
  sha256 "3a9a03b1b0277cc763c67179676b8b8aa29503db6db6cb7739c2d3ca9536921a"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "1a147ced2e0c45fb6a67281ccac1e4e6e7f82644fff2d6e53d0cac791ebcd151"
    sha256 cellar: :any_skip_relocation, big_sur:       "cd0497cca38f6a6ad914f34951bf4178cc689f3599ce000377f3049ead0ffbbd"
    sha256 cellar: :any_skip_relocation, catalina:      "88978464f63f97957d17ce8a3728a6575815ecb4ee6d2a670ade6c166e23c041"
    sha256 cellar: :any_skip_relocation, mojave:        "77f170344d5275b6eebbed7699d5f2406a30532b35edce0e60f1ab5cf312ff35"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1059695a96883652329d6688d085c8600914b7c2e597acbb0c2acb4cdfa4c78d"
  end

  depends_on "ghc" => :build
  depends_on "haskell-stack" => :build

  uses_from_macos "xz"

  def install
    # Let `stack` handle its own parallelization
    jobs = ENV.make_jobs
    ENV.deparallelize

    ghc_args = [
      "--system-ghc",
      "--no-install-ghc",
      "--skip-ghc-check",
    ]

    system "stack", "-j#{jobs}", "build", *ghc_args
    system "stack", "-j#{jobs}", "--local-bin-path=#{bin}", "install", *ghc_args
  end

  test do
    df = testpath/"Dockerfile"
    df.write <<~EOS
      FROM debian
    EOS
    assert_match "DL3006", shell_output("#{bin}/hadolint #{df}", 1)
  end
end
