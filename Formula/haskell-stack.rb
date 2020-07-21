require "language/haskell"

class HaskellStack < Formula
  include Language::Haskell::Cabal

  desc "The Haskell Tool Stack"
  homepage "https://haskellstack.org/"
  url "https://github.com/commercialhaskell/stack/archive/v2.3.1.tar.gz"
  sha256 "6701ddfc6d0be0c2bf0f75c84375e41923c5617f04222c5e582e7011c7f8fb83"
  license "BSD-3-Clause"
  head "https://github.com/commercialhaskell/stack.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "de6d561271fd1a422e4b4e85e9d71fd0cd87870d524e984aec3caab4762753ed" => :catalina
    sha256 "bffb38f057df538f22407b0c7e62cf224f60851b4845f8ef3cd7ee603f030fed" => :mojave
    sha256 "00038523c213ac96e759c01108a9867a55afc6ba3ea32646962493f29667b702" => :high_sierra
  end

  depends_on "cabal-install" => :build

  uses_from_macos "zlib"

  on_linux do
    depends_on "gmp"
  end

  # Stack requires stack to build itself. Yep.
  resource "bootstrap-stack" do
    on_macos do
      url "https://github.com/commercialhaskell/stack/releases/download/v2.3.1/stack-2.3.1-osx-x86_64.tar.gz"
      sha256 "73eee7e5f24d11fd0af00cb05f16119e86be5d578c35083250e6b85ed1ca3621"
    end

    on_linux do
      url "https://github.com/commercialhaskell/stack/releases/download/v2.3.1/stack-2.3.1-linux-x86_64.tar.gz"
      sha256 "b753cd21d446aea16a221326ec686e3acdf1b146c714a77b5d27fd855475554d"
    end
  end

  # Stack has very specific GHC requirements.
  # For 2.3.1, it requires 8.6.5.
  resource "bootstrap-ghc" do
    on_macos do
      url "https://downloads.haskell.org/~ghc/8.6.5/ghc-8.6.5-x86_64-apple-darwin.tar.xz"
      sha256 "dfc1bdb1d303a87a8552aa17f5b080e61351f2823c2b99071ec23d0837422169"
    end

    on_linux do
      url "https://downloads.haskell.org/~ghc/8.6.5/ghc-8.6.5-x86_64-deb8-linux.tar.xz"
      sha256 "c419fd0aa9065fe4d2eb9a248e323860c696ddf3859749ca96a84938aee49107"
    end
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
