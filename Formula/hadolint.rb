class Hadolint < Formula
  desc "Smarter Dockerfile linter to validate best practices"
  homepage "https://github.com/hadolint/hadolint"
  url "https://github.com/hadolint/hadolint/archive/v1.18.2.tar.gz"
  sha256 "5acbe40d2d9cc56955fda33572ce7283cb26b5b254fd557f4f1261937125b66f"
  license "GPL-3.0-only"

  bottle do
    cellar :any_skip_relocation
    sha256 "64d6d63f6daefe1e8a72ee02c7691396bde29d247585212a088748a7e143ecef" => :catalina
    sha256 "d3fa0fd39ce578432959f910b30bcd03419cc4b8f31aed34850dc5917d995861" => :mojave
    sha256 "d53fee21f0473583d3214f999f4de2a9367928f09085b67335e75a2cddf883b1" => :high_sierra
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
