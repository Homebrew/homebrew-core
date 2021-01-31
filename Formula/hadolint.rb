class Hadolint < Formula
  desc "Smarter Dockerfile linter to validate best practices"
  homepage "https://github.com/hadolint/hadolint"
  url "https://github.com/hadolint/hadolint/archive/v1.21.0.tar.gz"
  sha256 "9f7501bb1cd3336ef1f6f63e09937dd1e99433a766a719094dc09ac22e44a5ac"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur: "966f01b9cd17172eaf2f8ec629bf16329b363ef82faa70310a3f71216e94a8a6"
    sha256 cellar: :any_skip_relocation, catalina: "b1ab86966cdd39a778eb9a641a1c80100f12f3d67c490c1f1a71df1ef4ecd83d"
    sha256 cellar: :any_skip_relocation, mojave: "9341df3a445fcc143c6de6b8e3223b63638937642488693ae7de5572a270b627"
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
