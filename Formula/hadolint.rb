class Hadolint < Formula
  desc "Smarter Dockerfile linter to validate best practices"
  homepage "https://github.com/hadolint/hadolint"
  url "https://github.com/hadolint/hadolint/archive/v2.2.0.tar.gz"
  sha256 "fb7093d0f4f071c48beb01f90b9d4251f7a14c0fcae32493a4b181c3567b74aa"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "3c01438ad61a74345c9f39e9c0d172b5b3757feb8a291b1e11b12a136e8f83e9"
    sha256 cellar: :any_skip_relocation, catalina: "f20a5cf1ebb062e7a2b6a0b273df8658e8d0c5120d0190bcada9b12798a646f3"
    sha256 cellar: :any_skip_relocation, mojave:   "5a84986ce05ea1eac91d811b9aee9cb327280860834bfff2b5fe0157ca84ecaf"
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
