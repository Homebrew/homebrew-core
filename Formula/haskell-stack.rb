class HaskellStack < Formula
  desc "Cross-platform program for developing Haskell projects"
  homepage "https://haskellstack.org/"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/commercialhaskell/stack.git", branch: "master"

  stable do
    url "https://github.com/commercialhaskell/stack/archive/v2.9.3.tar.gz"
    sha256 "52eff38bfc687b1a0ded7001e9cd83a03b9152a4d54347df7cf0b3dd92196248"

    # Avoid unix-compat's System.PosixCompat.User.
    # Remove with `stable` block on next release.
    patch :DATA
  end

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "56d83f5bc97cbb3d3e64b964cbf597f429e4b9e17e00758e4e658d00a2b14ac0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "85151dd27dd85e1362aca06537ebebbd6554e4060fadb36eb7756fd7af254d05"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a584c251efb28bca574ca2156007da4b5b95825f3a6df1b7695f9c8320000fd4"
    sha256 cellar: :any_skip_relocation, ventura:        "7c856ac06145ad589ac2520208edb0acb6d5f50db04006d74f1e020a1eb46032"
    sha256 cellar: :any_skip_relocation, monterey:       "7a5daa9304d5bfe5b9f4d3e87a78f5aa15de509fe0883cbd06569b1340d4dceb"
    sha256 cellar: :any_skip_relocation, big_sur:        "f5b4ae812cb3a1dbbc3bb32cc587b45d75dac02b482cc22cb37ce10db0921182"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9b43b663d28a2559bb8b92d048b6e64a77f763bb0715083ac5f112ab172fc958"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc@9.2" => :build

  uses_from_macos "zlib"

  # All ghc versions before 9.2.1 requires LLVM Code Generator as a backend on
  # ARM. GHC 8.10.7 user manual recommend use LLVM 9 through 12 and we met some
  # unknown issue with LLVM 13 before so conservatively use LLVM 12 here.
  #
  # References:
  #   https://downloads.haskell.org/~ghc/8.10.7/docs/html/users_guide/8.10.7-notes.html
  #   https://gitlab.haskell.org/ghc/ghc/-/issues/20559
  on_arm do
    depends_on "llvm@12"
  end

  def install
    # Remove locked dependencies which only work with a single patch version of GHC.
    # If there are issues resolving dependencies, then can consider bootstrapping with stack instead.
    (buildpath/"cabal.project").unlink

    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args

    bin.env_script_all_files libexec, PATH: "${PATH}:#{Formula["llvm@12"].opt_bin}" if Hardware::CPU.arm?
  end

  test do
    system bin/"stack", "new", "test"
    assert_predicate testpath/"test", :exist?
    assert_match "# test", (testpath/"test/README.md").read
  end
end

__END__
--- a/src/Stack/Config.hs
+++ b/src/Stack/Config.hs
@@ -89,7 +89,7 @@ import           System.Console.ANSI
 import           System.Environment
 import           System.Info.ShortPathName ( getShortPathName )
 import           System.PosixCompat.Files ( fileOwner, getFileStatus )
-import           System.PosixCompat.User ( getEffectiveUserID )
+import           System.Posix.User ( getEffectiveUserID )
 
 -- | If deprecated path exists, use it and print a warning.
 -- Otherwise, return the new path.
--- a/src/Stack/Docker.hs
+++ b/src/Stack/Docker.hs
@@ -66,7 +66,7 @@ import           System.IO.Unsafe ( unsafePerformIO )
 import           System.Posix.Signals
 import qualified System.Posix.User as PosixUser
 #endif
-import qualified System.PosixCompat.User as User
+import qualified System.Posix.User as User
 import qualified System.PosixCompat.Files as Files
 import           System.Terminal ( hIsTerminalDeviceOrMinTTY )
 import           Text.ParserCombinators.ReadP ( readP_to_S )
