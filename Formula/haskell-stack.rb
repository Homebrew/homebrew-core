require "language/haskell"

class HaskellStack < Formula
  include Language::Haskell::Cabal

  desc "The Haskell Tool Stack"
  homepage "https://haskellstack.org/"
  url "https://github.com/commercialhaskell/stack/archive/v2.3.1.tar.gz"
  sha256 "6701ddfc6d0be0c2bf0f75c84375e41923c5617f04222c5e582e7011c7f8fb83"
  head "https://github.com/commercialhaskell/stack.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "65f8b095630d1018849e6e845efc33449af957143cddf2a1917908d7d11b4df6" => :catalina
    sha256 "228c583aa3eb036ca6aaa8a9b9fe6ad152790bd537bffdaca295aa9f497174e7" => :mojave
    sha256 "28d341adbc1acf444fb0f71899f14d81d772d5ba59ae6eebe201ac24fd6e3aa8" => :high_sierra
  end

  depends_on "cabal-install" => :build

  uses_from_macos "zlib"

  # Stack requires stack to build itself. Yep.
  resource "bootstrap-stack" do
    url "https://github.com/commercialhaskell/stack/releases/download/v2.3.1/stack-2.3.1-osx-x86_64.tar.gz"
    sha256 "73eee7e5f24d11fd0af00cb05f16119e86be5d578c35083250e6b85ed1ca3621"
  end

  # Stack has very specific GHC requirements.
  # For 2.3.1, it requires 8.6.5.
  resource "bootstrap-ghc" do
    url "https://downloads.haskell.org/~ghc/8.6.5/ghc-8.6.5-x86_64-apple-darwin.tar.xz"
    sha256 "dfc1bdb1d303a87a8552aa17f5b080e61351f2823c2b99071ec23d0837422169"
  end

  def install
    (buildpath/"bootstrap-stack").install resource("bootstrap-stack")
    ENV.append_path "PATH", "#{buildpath}/bootstrap-stack"

    resource("bootstrap-ghc").stage do
      binary = buildpath/"bootstrap-ghc"

      system "./configure", "--prefix=#{binary}"
      ENV.deparallelize { system "make", "install" }

      ENV.prepend_path "PATH", binary/"bin"
    end

    cabal_sandbox do
      # Let `stack` handle its own parallelization
      # Prevents "install: mkdir ... ghc-7.10.3/lib: File exists"
      jobs = ENV.make_jobs
      ENV.deparallelize

      system "stack", "-j#{jobs}", "--stack-yaml=stack.yaml",
             "--system-ghc", "--no-install-ghc", "build"
      system "stack", "-j#{jobs}", "--stack-yaml=stack.yaml",
             "--system-ghc", "--no-install-ghc", "--local-bin-path=#{bin}",
             "install"
    end
  end

  test do
    system bin/"stack", "new", "test"
  end
end
