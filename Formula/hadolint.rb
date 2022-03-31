class Hadolint < Formula
  desc "Smarter Dockerfile linter to validate best practices"
  homepage "https://github.com/hadolint/hadolint"
  url "https://github.com/hadolint/hadolint/archive/v2.10.0.tar.gz"
  sha256 "7a17d6227c9c087076aa890c9678956d0bc570eb662aa432a73d3e7c94f6b158"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "610529133b9963fadf098f8aa335237483941ff1175b8c6f9a2bf77f546f3c9a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d1a6a63b5736d9e8e510e0460ab95403b5c8dc84be352f1624f769b4b2c8f92a"
    sha256 cellar: :any_skip_relocation, monterey:       "1f23793885e5213ab3ceaef0282b8777d1a22613a3eac40fe2e810f19e2b129e"
    sha256 cellar: :any_skip_relocation, big_sur:        "be47e2d084751e1e49bfd2c24298caae72f2c632322c044b21b03d173e2ca1b3"
    sha256 cellar: :any_skip_relocation, catalina:       "577a5ca21fe46f687742b7db07dc77fcf8ca970bae03db33312631ccccc64f18"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a63ba52e858570e0b8b14734a39290069d07fba445f93a7f57b013e244c7dee0"
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
