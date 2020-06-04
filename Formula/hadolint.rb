require "language/haskell"

class Hadolint < Formula
  include Language::Haskell::Cabal

  desc "Smarter Dockerfile linter to validate best practices"
  homepage "https://github.com/hadolint/hadolint"
  url "https://github.com/hadolint/hadolint/archive/v1.17.7.tar.gz"
  sha256 "67ffa0385a83c611e0e7bf7f8d3105f626b24d94c7f753645d55b0d0fd8f53e9"

  bottle do
    cellar :any_skip_relocation
    sha256 "93f0d394892e8a508027e4d46e53c8df3b5e13c12d747a78ac8fd20e390a2fb6" => :catalina
    sha256 "6087ee380c2b66cc7b7c2cf926402077c5d2deac7333237eecb7a4c82286b8b2" => :mojave
    sha256 "397569db01cf56a8fa5693d70598d4bf48c361db11b3b51479a7887c7ed93cef" => :high_sierra
  end

  depends_on "haskell-stack" => :build

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
