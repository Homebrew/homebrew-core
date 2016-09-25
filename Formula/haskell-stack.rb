require "language/haskell"

class HaskellStack < Formula
  include Language::Haskell::Cabal

  desc "The Haskell Tool Stack"
  homepage "https://haskellstack.org/"
  url "https://github.com/commercialhaskell/stack/releases/download/v1.2.0/stack-1.2.0-sdist-0.tar.gz"
  version "1.2.0"
  sha256 "872d29a37fe9d834c023911a4f59b3bee11e1f87b3cf741a0db89dd7f6e4ed64"
  revision 2

  head "https://github.com/commercialhaskell/stack.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "194f69e57dfc5def4d743f46bfc891b04ac52a7c9aecd9020760c7100d10fbfe" => :el_capitan
    sha256 "a1b7f73dc42de70d6a0a5028dcdb44dfc6764b00ea12619de1efc341673f8d9f" => :yosemite
    sha256 "5b27d778e5291d28645f56dac058461b0836c52d601c3fd955eac54669e5df57" => :mavericks
  end

  option "without-bootstrap", "Don't bootstrap a stage 2 stack"

  # malformed mach-o: load commands size (40192) > 32768
  depends_on MaximumMacOSRequirement => :el_capitan if build.bottle?

  depends_on "ghc" => :build
  depends_on "cabal-install" => :build

  def install
    if MacOS.version >= :sierra
      raise <<-EOS.undent
        This formula does not compile on macOS Sierra due to an upstream GHC
        incompatiblity. Please use the pre-built bottle binary instead of attempting to
        build from source. For more details see
          https://ghc.haskell.org/trac/ghc/ticket/12479
          https://github.com/commercialhaskell/stack/issues/2577
      EOS
    end

    if build.with? "bootstrap"
      cabal_sandbox do
        cabal_install
        # Let `stack` handle its own parallelization
        # Prevents "install: mkdir ... ghc-7.10.3/lib: File exists"
        jobs = ENV.make_jobs
        ENV.deparallelize do
          system "stack", "-j#{jobs}", "setup"
          system "stack", "-j#{jobs}", "--local-bin-path=#{bin}", "install"
        end
      end
    else
      install_cabal_package
    end

    # Remove the unneeded rpaths so that the binary works on Sierra
    rpaths = Utils.popen_read("otool -l #{bin}/stack").split("\n")
    rpaths = rpaths.inject([]) do |r, e|
      if e =~ /^ +path (.*) \(offset.*/
        r << $~[1]
      else
        r
      end
    end
    rpaths.each do |r|
      system "install_name_tool", "-delete_rpath", r, bin/"stack"
    end
  end

  test do
    system bin/"stack", "new", "test"
  end
end
