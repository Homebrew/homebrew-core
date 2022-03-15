class Hadolint < Formula
  desc "Smarter Dockerfile linter to validate best practices"
  homepage "https://github.com/hadolint/hadolint"
  url "https://github.com/hadolint/hadolint/archive/v2.9.1.tar.gz"
  sha256 "1b11bb9f35c1463dcf8607f20d36e474fad73032a8c8adf9abb8b3ae5da68d71"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ae917aafac683cb5b10987a2f54a7ebf7da82f643c268344749ec928923a56d4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5a8d46bc212a63d51b809a469064bb35456b1922c285da387af600850ae8d40a"
    sha256 cellar: :any_skip_relocation, monterey:       "26688b87419b921595d8b0b67a3946c7cd5783aca075ec94feb9962b345a941d"
    sha256 cellar: :any_skip_relocation, big_sur:        "de2645a70e86e2e828912d98e050ebb852a66924e5052d452fd0596a4112373f"
    sha256 cellar: :any_skip_relocation, catalina:       "4055b2d9f94222a4c8162c0b7ec1d8cf03ec385587f40d571e6446237e061994"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3dd1bfa5cb9bef03ca333213b1df26451c24b697bd6ba7c6b6a34f399416fd18"
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
