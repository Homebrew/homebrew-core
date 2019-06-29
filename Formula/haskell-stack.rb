require "language/haskell"

class HaskellStack < Formula
  include Language::Haskell::Cabal

  desc "The Haskell Tool Stack"
  homepage "https://haskellstack.org/"
  url "https://github.com/commercialhaskell/stack/archive/v2.1.1.tar.gz"
  sha256 "10c0119456748b189724ee42dea093c324d101487c3d75d57eb625675bb57424"
  head "https://github.com/commercialhaskell/stack.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "3645df648aaf9fbd701523e7df4ad9dbb8268cdf5dc17f2dce2c7548e21e52e5" => :mojave
    sha256 "f8cb22836da5319f162654c4b288b1a4984ddaa30d766874e4d2bbedfd026f56" => :high_sierra
    sha256 "5e04d6ebfc4790fb30167305fa2fdfc983af1a75d0e8706616e3d9c124e1febb" => :sierra
  end

  depends_on "cabal-install" => :build
  uses_from_macos "zlib"

  # Stack requires stack to build itself. Yep.
  resource "bootstrap-stack" do
    url "https://github.com/commercialhaskell/stack/releases/download/v2.1.1/stack-2.1.1-osx-x86_64.tar.gz"
    sha256 "f4af329419fb6ee9655b22db04d72a35a5a225e78bdcc605d78334a72c8c2332"
  end

  # Stack has very specific GHC requirements.
  # For 2.1.1, it requires 8.4.4.
  resource "bootstrap-ghc" do
    url "https://downloads.haskell.org/~ghc/8.4.4/ghc-8.4.4-x86_64-apple-darwin.tar.xz"
    sha256 "28dc89ebd231335337c656f4c5ead2ae2a1acc166aafe74a14f084393c5ef03a"
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

      system "stack", "-j#{jobs}", "--stack-yaml=stack-lts-12.yaml",
             "--system-ghc", "--no-install-ghc", "build"
      system "stack", "-j#{jobs}", "--stack-yaml=stack-lts-12.yaml",
             "--system-ghc", "--no-install-ghc", "--local-bin-path=#{bin}",
             "install"
    end
  end

  test do
    system bin/"stack", "new", "test"
  end
end
