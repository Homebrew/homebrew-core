class Hadolint < Formula
  desc "Smarter Dockerfile linter to validate best practices"
  homepage "https://github.com/hadolint/hadolint"
  url "https://github.com/hadolint/hadolint/archive/v2.7.0.tar.gz"
  sha256 "791221086ea1973e0ed6e325a01fd2e3a38f49c1d6b1773d680fd647a11bc147"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "b345719e7030dad180b81669fbf7a967d984c6887b6e880f0c031b38e95e52d3"
    sha256 cellar: :any_skip_relocation, big_sur:       "abce0685f4b3f1ead842ff06ad3558241df8774f688d47756ecd35ebcfab3269"
    sha256 cellar: :any_skip_relocation, catalina:      "5eab02ca98f5edb9d0739b3e32a571a2ccc7ff3a1587f6ec551538920e501f63"
    sha256 cellar: :any_skip_relocation, mojave:        "c0fa969e5b180cf5ddd5f46ddee81bf76bebe902f40e7a248ff235930b37d60f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1f3cc5ceb8966c2ee52d7ff8d5a54ab8c3a6308f0581f909fa933cf86fe83035"
  end

  depends_on "ghc" => :build
  depends_on "haskell-stack" => :build

  uses_from_macos "xz"

  def install
    # Let `stack` handle its own parallelization
    jobs = ENV.make_jobs
    ENV.deparallelize

    ghc_args = [
      "--system-ghc",
      "--no-install-ghc",
      "--skip-ghc-check",
    ]

    system "stack", "-j#{jobs}", "build", *ghc_args
    system "stack", "-j#{jobs}", "--local-bin-path=#{bin}", "install", *ghc_args
  end

  test do
    df = testpath/"Dockerfile"
    df.write <<~EOS
      FROM debian
    EOS
    assert_match "DL3006", shell_output("#{bin}/hadolint #{df}", 1)
  end
end
