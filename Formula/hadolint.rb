class Hadolint < Formula
  desc "Smarter Dockerfile linter to validate best practices"
  homepage "https://github.com/hadolint/hadolint"
  url "https://github.com/hadolint/hadolint/archive/v1.18.2.tar.gz"
  sha256 "5acbe40d2d9cc56955fda33572ce7283cb26b5b254fd557f4f1261937125b66f"
  license "GPL-3.0-only"

  bottle do
    cellar :any_skip_relocation
    sha256 "c45ebcb4b182164ce214940b48cfbae73342280d3a6236c6b9b73e518d61d364" => :catalina
    sha256 "1f7d707912486724b01bc011ca7c4b9249b1c4ea6cb8e009c69b3ce8006d25f2" => :mojave
    sha256 "c9fd5ed57fbd001e04e8e8f26921d5943d864f3248a97dcd15f7a427575a9654" => :high_sierra
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
