class Hadolint < Formula
  desc "Smarter Dockerfile linter to validate best practices"
  homepage "https://github.com/hadolint/hadolint"
  url "https://github.com/hadolint/hadolint/archive/v2.4.1.tar.gz"
  sha256 "dade1c9659471b3aff220f0a321e98c45e24584c7bd0d5d20bd95c64a1269bdd"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "e139f730ae1c5508ee710cbcf0f6453f0c26e8b40beefe910999cc97157fcd0b"
    sha256 cellar: :any_skip_relocation, catalina: "f4b116bbfbc9cb73c045b5369fa2ec92085a025f1065d3c4c0a9ab27e96ce52f"
    sha256 cellar: :any_skip_relocation, mojave:   "e13abd67b5d34f4bd372a3f6c5ddf6ba8c0fed41a5b00e4a36b30b755c396e66"
  end

  depends_on "ghc" => :build
  depends_on "haskell-stack" => :build
  depends_on "llvm" => :build if Hardware::CPU.arm?

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
