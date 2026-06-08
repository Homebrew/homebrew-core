class GitAnnex < Formula
  desc "Manage files with git without checking in file contents"
  homepage "https://git-annex.branchable.com/"
  url "https://hackage.haskell.org/package/git-annex-10.20260601/git-annex-10.20260601.tar.gz"
  sha256 "cce20dbea9f1626e0c680267ffb7e5ef2d95a9e0c34bdc7d153c30cb1f5687f8"
  license all_of: ["AGPL-3.0-or-later", "BSD-2-Clause", "BSD-3-Clause",
                   "GPL-2.0-only", "GPL-3.0-or-later", "MIT"]
  head "git://git-annex.branchable.com/", branch: "master"

  livecheck do
    url "https://hackage.haskell.org/package/git-annex"
    regex(/href=.*?git-annex[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "de4e256b878507f4ef14a73e9d9ca0df23baad95415afec3a97f9639a967ebc6"
    sha256 cellar: :any, arm64_sequoia: "f3b0934b42adf7297e9c6ca31ddb7aa0434f8ba2dd57fd376749a31c25697307"
    sha256 cellar: :any, arm64_sonoma:  "ab82a1533fa4b4d7eda15452ee045927ea2c6059fd6e8ceb36ff8f95bdbbddb6"
    sha256 cellar: :any, sonoma:        "17e105dd2c2969da793b7ca71b1f524cb82af8ee6715fc4de70f12c5f6594833"
    sha256 cellar: :any, arm64_linux:   "296546fde44dc70aeac223daaa1202ec38d15cf50204d5f03034f566c9b42e8d"
    sha256 cellar: :any, x86_64_linux:  "60a2a2e0bbf3a84cf6cfc0bf94ec81d7b6ed5d6db5b1094a9f7510275ca09abf"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "pkgconf" => :build
  depends_on "gmp"
  depends_on "libmagic"

  uses_from_macos "libffi"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  # Hide conflicting imports. Probably caused by `--allow-newer` flag
  patch :DATA

  def install
    # Workaround to build aeson with GHC 9.14, https://github.com/haskell/aeson/issues/1155
    args = ["--allow-newer=base,containers,template-haskell"]

    system "cabal", "v2-update"
    system "cabal", "v2-install", *args, *std_cabal_v2_args, "--flags=+S3 +Servant"
    bin.install_symlink "git-annex" => "git-annex-shell"
    bin.install_symlink "git-annex" => "git-remote-annex"
    bin.install_symlink "git-annex" => "git-remote-tor-annex"
  end

  service do
    run [opt_bin/"git-annex", "assistant", "--autostart"]
  end

  test do
    # make sure git can find git-annex
    ENV.prepend_path "PATH", bin

    system "git", "init"
    system "git", "annex", "init"
    (testpath/"Hello.txt").write "Hello!"
    refute_predicate (testpath/"Hello.txt"), :symlink?
    assert_match(/^add Hello.txt.*ok.*\(recording state in git\.\.\.\)/m, shell_output("git annex add ."))
    system "git", "commit", "-a", "-m", "Initial Commit"
    assert_predicate (testpath/"Hello.txt"), :symlink?

    # make sure the various remotes were built
    assert_match "remote types: git gcrypt p2p S3 bup directory rsync web bittorrent " \
                 "webdav adb tahoe glacier ddar git-lfs httpalso borg rclone hook external",
                 shell_output("git annex version | grep 'remote types:'").chomp

    # The steps below are necessary to ensure the directory cleanly deletes.
    # git-annex guards files in a way that isn't entirely friendly of automatically
    # wiping temporary directories in the way `brew test` does at end of execution.
    system "git", "rm", "Hello.txt", "-f"
    system "git", "commit", "-a", "-m", "Farewell!"
    system "git", "annex", "unused"
    assert_match "dropunused 1 ok", shell_output("git annex dropunused 1 --force")
    system "git", "annex", "uninit"
  end
end

__END__
diff --git a/Utility/Url.hs b/Utility/Url.hs
index 40fa483..0c1f973 100644
--- a/Utility/Url.hs
+++ b/Utility/Url.hs
@@ -55,7 +55,7 @@ import Utility.Url.Parse
 import qualified Utility.FileIO as F
 
 import Network.URI
-import Network.HTTP.Types
+import Network.HTTP.Types hiding (hAcceptEncoding, hContentDisposition, hContentRange)
 import qualified System.FilePath.Posix as UrlPath
 import qualified Data.CaseInsensitive as CI
 import qualified Data.ByteString as B
