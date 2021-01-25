class Hadolint < Formula
  desc "Smarter Dockerfile linter to validate best practices"
  homepage "https://github.com/hadolint/hadolint"
  url "https://github.com/hadolint/hadolint/archive/v1.19.0.tar.gz"
  sha256 "bf5270f68b26a14197cd2f34490a2a3a696b07e2492bfef979adb096c77b0c1e"
  license "GPL-3.0-only"

  bottle do
    cellar :any_skip_relocation
    sha256 "d02e9b6a838b0054c4288beec7388c84350727334d0d63dedd6e9e33b7e57d2e" => :big_sur
    sha256 "4261c178d1bc9066e8d645712207a665cf16650c5b22493c1dd9718dbc8a4ab3" => :catalina
    sha256 "f9d485e36150f6f86b64c58d1670bac62c0808e803150515ce74335949f4e18b" => :mojave
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
