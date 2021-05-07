class Hadolint < Formula
  desc "Smarter Dockerfile linter to validate best practices"
  homepage "https://github.com/hadolint/hadolint"
  url "https://github.com/hadolint/hadolint/archive/v2.4.0.tar.gz"
  sha256 "fa59e09910d52220dc38aec447bb1c3a3d02f93871fec3415744041da190d256"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "9f27782d650f33ace337ff58046bfbc0928ad711f0b86da4b190e4dc049a8a59"
    sha256 cellar: :any_skip_relocation, catalina: "73cce67bd7cada69382ada96a838fbd405236e64d3cc9ec6d47a4f24d72202ea"
    sha256 cellar: :any_skip_relocation, mojave:   "a08e0a5b9236d0b8d2ba01e7b77f53a34587cd932c0668518ff0d681ef2e6ad3"
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
