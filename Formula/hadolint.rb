class Hadolint < Formula
  desc "Smarter Dockerfile linter to validate best practices"
  homepage "https://github.com/hadolint/hadolint"
  url "https://github.com/hadolint/hadolint/archive/v2.1.0.tar.gz"
  sha256 "e631a86392bdf6ebfed737f99f05558b7f06b063215180b41d6e9d7fb8fe6ce4"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "3c6cc1fb4733be6d6a326dd08609c1afa65cda5bff6117f2b28574e4ca724f2e"
    sha256 cellar: :any_skip_relocation, catalina: "e6c611ce654ab63465cd87a52583ce8e2478e861ce06bf563ac1a05ca1581f69"
    sha256 cellar: :any_skip_relocation, mojave:   "e7db9635f6fcd06fefed2a51ca4b67b8b0826c0d1af14e4bce7fbe90c90c1bf5"
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
