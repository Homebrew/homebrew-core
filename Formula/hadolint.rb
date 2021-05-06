class Hadolint < Formula
  desc "Smarter Dockerfile linter to validate best practices"
  homepage "https://github.com/hadolint/hadolint"
  url "https://github.com/hadolint/hadolint/archive/v2.4.0.tar.gz"
  sha256 "fa59e09910d52220dc38aec447bb1c3a3d02f93871fec3415744041da190d256"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "b988fa5a14f8c03b67a6ad8db13bd5c73bf13ea92386f0a78cfb411dd3c59d56"
    sha256 cellar: :any_skip_relocation, catalina: "e62114ac7acbf14fd341a95f75a78a7f22c2930447bbe85f1306fe0b54318a8d"
    sha256 cellar: :any_skip_relocation, mojave:   "96f4ceb123170e542f09de33853bb2da6645d362b06690dc1bf0da3d7b9816b0"
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
