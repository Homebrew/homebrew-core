class Hadolint < Formula
  desc "Smarter Dockerfile linter to validate best practices"
  homepage "https://github.com/hadolint/hadolint"
  url "https://github.com/hadolint/hadolint/archive/v2.9.2.tar.gz"
  sha256 "de789a2fb4d92d927e8e126fb54fec9dd2b58baf05d7aa7843cf5347428bb543"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "01aa18637c357a4f555d0f8a0acf576bb56e26f75f77e9c34c6d0c09917ba9c3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "506557e125b3c6af303a5353f62ca26eea0d4572d3509a17a99fb5cce5cf7220"
    sha256 cellar: :any_skip_relocation, monterey:       "88170823421008d191d8f10b1370de5fc1414c0f014a13e8d3efefca5ebfe2d6"
    sha256 cellar: :any_skip_relocation, big_sur:        "346b2c201167e0325b71df9b478a1bc5267b49b28e1acaa5187e6d295365886d"
    sha256 cellar: :any_skip_relocation, catalina:       "6d74701f7ea667825b602633643c6421b89ba0a99d82c5936e92c2ac3c643fb8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bff3d3fa9d4aaf076cec506c270db855a67d87c5753b0918a77c93cb5c05f292"
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
