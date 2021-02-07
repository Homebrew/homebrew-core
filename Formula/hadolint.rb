class Hadolint < Formula
  desc "Smarter Dockerfile linter to validate best practices"
  homepage "https://github.com/hadolint/hadolint"
  url "https://github.com/hadolint/hadolint/archive/v1.22.0.tar.gz"
  sha256 "ab208e7f4d321a43fb9a3d94a26c59afcd7dd5e2e5862a90d38af99504a45403"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "d8b28a1d834b26bdc59b5c31ce408eea4185875873f3733fc5f49dd3a029584c"
    sha256 cellar: :any_skip_relocation, catalina: "70616f0d13bd3f83d8378e667ce8ce7f612e11f78f5ed85ed556baa05a2ebe3f"
    sha256 cellar: :any_skip_relocation, mojave:   "abf4022ad9a314129a19ddbf0580d645343555e0452e78116a0cef8d6f5d69c3"
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
