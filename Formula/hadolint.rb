class Hadolint < Formula
  desc "Smarter Dockerfile linter to validate best practices"
  homepage "https://github.com/hadolint/hadolint"
  url "https://github.com/hadolint/hadolint/archive/v2.6.1.tar.gz"
  sha256 "3a9a03b1b0277cc763c67179676b8b8aa29503db6db6cb7739c2d3ca9536921a"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "fde2fccc8d7f565954f37d0a30652dcdd611f63c5a302deff6ab12f8eace44d2"
    sha256 cellar: :any_skip_relocation, big_sur:       "565d9b6cc49bf125ddb4cb3a10504d0122391fbef43f366e4e162493e903e38d"
    sha256 cellar: :any_skip_relocation, catalina:      "cf4d9ab9167be5b7858a3a086eef4c16b8c46adaeeee6ad83b70e2f6de0f0dba"
    sha256 cellar: :any_skip_relocation, mojave:        "0db3e66c64300a704f34c7d6dc6f56d00ab8d31da6da4f5018b575da0d3e19df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f31b7f139119b4362c639debc0db681d366d5e9a07d6e26993a7bdffe0a234d0"
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
