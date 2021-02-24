class Hadolint < Formula
  desc "Smarter Dockerfile linter to validate best practices"
  homepage "https://github.com/hadolint/hadolint"
  url "https://github.com/hadolint/hadolint/archive/v1.22.1.tar.gz"
  sha256 "d24080c9960da00c7d2409d51d0bbe8b986e86be345ed7410d6ece2899e7ac01"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "b6679a357d790e8ebfd6d00d289556302464f63616795a27fdc16988c06c31d2"
    sha256 cellar: :any_skip_relocation, catalina: "a069721e3b70d7c9ef7c4689fc586201aa1890e73ab85e3769a62825011fb265"
    sha256 cellar: :any_skip_relocation, mojave:   "8add1911472e40307e1d5e2dd21d2a5154616e5dbc43f0fa339baf53d8466cee"
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
