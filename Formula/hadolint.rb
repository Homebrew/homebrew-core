class Hadolint < Formula
  desc "Smarter Dockerfile linter to validate best practices"
  homepage "https://github.com/hadolint/hadolint"
  url "https://github.com/hadolint/hadolint/archive/v2.10.0.tar.gz"
  sha256 "7a17d6227c9c087076aa890c9678956d0bc570eb662aa432a73d3e7c94f6b158"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "47a602a05d2f725975fee4437606cfde8930db9dc9ce897c5b123243fd25eb25"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cf554d10927910209503c4a673d378d8ba5be9c7d2f6e1f2761de08ab77a9985"
    sha256 cellar: :any_skip_relocation, monterey:       "b8efaf46aa705bde9b6174d613e7c388b00571e8180e0f3578383ceb59198278"
    sha256 cellar: :any_skip_relocation, big_sur:        "c580ee4ab092afe88ccf8b68c8654cb4a639d68432e72a6532c3a8bbcb5b92f6"
    sha256 cellar: :any_skip_relocation, catalina:       "cdbd9bf2d766b0d75df8bc8cfe6397eaf7ba91f3ccf4519703f0aad148ff99f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "80adffee09ee9cf1121b7d286871c6751806a8ce2b81115e77a106c4e27d3866"
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
