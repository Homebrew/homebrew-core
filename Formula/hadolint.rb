class Hadolint < Formula
  desc "Smarter Dockerfile linter to validate best practices"
  homepage "https://github.com/hadolint/hadolint"
  url "https://github.com/hadolint/hadolint/archive/v1.22.1.tar.gz"
  sha256 "d24080c9960da00c7d2409d51d0bbe8b986e86be345ed7410d6ece2899e7ac01"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "7a10dcfee93e596b79c018df6cbc12276dde041bbed763757e466b8c51c1d0cf"
    sha256 cellar: :any_skip_relocation, catalina: "05a5bdcf3654a5fce4afb095666163a562b90bc5cd5c37499d1101f39e0d4536"
    sha256 cellar: :any_skip_relocation, mojave:   "bd258ce4d30e30bf2c845a10230a6cd682a836192fe3f0098504b1d4da06bd29"
  end

  depends_on "ghc" => :build
  depends_on "haskell-stack" => :build

  uses_from_macos "xz"

  on_linux do
    depends_on "gmp"
  end

  def install
    # Let `stack` handle its own parallelization
    jobs = ENV.make_jobs
    ENV.deparallelize

    system "stack", "-j#{jobs}", "build"
    system "stack", "-j#{jobs}", "--local-bin-path=#{bin}", "install"
  end

  test do
    df = testpath/"Dockerfile"
    df.write <<~EOS
      FROM debian
    EOS
    assert_match "DL3006", shell_output("#{bin}/hadolint #{df}", 1)
  end
end
