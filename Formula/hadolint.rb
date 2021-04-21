class Hadolint < Formula
  desc "Smarter Dockerfile linter to validate best practices"
  homepage "https://github.com/hadolint/hadolint"
  url "https://github.com/hadolint/hadolint/archive/v2.3.0.tar.gz"
  sha256 "0ec415212d578f6e377eac2a059d86d34ad53701be6ae7664befcd8ea2225a16"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "6c0ba0a404410953690f04c169e4445837a989bdc0d5bbcdd14e191c9b9db627"
    sha256 cellar: :any_skip_relocation, catalina: "b4bb3e92cd109657d342331a2a8ed3f27c10693e329d2ccba34c4853f09df2ae"
    sha256 cellar: :any_skip_relocation, mojave:   "b307dfc69e486036695da922dd6d7cd51c351e61803f363b1f78b56bb2ed0138"
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
