class Hadolint < Formula
  desc "Smarter Dockerfile linter to validate best practices"
  homepage "https://github.com/hadolint/hadolint"
  url "https://github.com/hadolint/hadolint/archive/v2.5.0.tar.gz"
  sha256 "0de36f1fa8f86183d51722cda142dd41039aab557b4e8d0bfc6f5fe265bf9fa1"
  license "GPL-3.0-only"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "83b735a443ef94215af0d3aa0987996c80da2c53a57b1934c1a802f3bb4df0df"
    sha256 cellar: :any_skip_relocation, big_sur:       "070d291918f60f932cd52087aecda626b0022ea15c1e30f349466a06842ad16f"
    sha256 cellar: :any_skip_relocation, catalina:      "e9ed3f5d51185405a85a23805e1c25c745207c2466c9d52b2acf12dc61f4443f"
    sha256 cellar: :any_skip_relocation, mojave:        "aa89cf879b8d9e440dd22b2c37692f636ef8e3c0e9843e3b33084ebaa4fd48bd"
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
