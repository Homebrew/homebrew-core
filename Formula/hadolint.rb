class Hadolint < Formula
  desc "Smarter Dockerfile linter to validate best practices"
  homepage "https://github.com/hadolint/hadolint"
  url "https://github.com/hadolint/hadolint/archive/v2.9.2.tar.gz"
  sha256 "de789a2fb4d92d927e8e126fb54fec9dd2b58baf05d7aa7843cf5347428bb543"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fbd4167b4f1c90c86b581c33472d9327da687c9a22bae5ddc8976ea470bf8513"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e94ba605593f2811e50db5f2ce74ce7550a33b241f23f353f7c4a9d030d33922"
    sha256 cellar: :any_skip_relocation, monterey:       "5862dc8527aa60c018986c8a07edfb95b64a2aa75a9d1f54c46ed775d78ea470"
    sha256 cellar: :any_skip_relocation, big_sur:        "b35ebd0fddcdaf07b371605f88736e8717d262a0f3c005c17d58831dd8b8d735"
    sha256 cellar: :any_skip_relocation, catalina:       "9e5f758e4878e698b4bf637d69724e62966565f1cdc828b5a7ad87d3ed5274df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "977ffe9a745b23adc8a7a88aae9c1cee7a78054a253204c2cedd47b06bf64bc7"
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
