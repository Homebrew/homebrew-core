class GitAnnex < Formula
  desc "Manage files with git without checking in file contents"
  homepage "https://git-annex.branchable.com/"
  url "https://hackage.haskell.org/package/git-annex-10.20250721/git-annex-10.20250721.tar.gz"
  sha256 "217fd675dba96fc82734d08b7951ad596f2ba4f99bb01fa848528d9874828aac"
  license all_of: ["AGPL-3.0-or-later", "BSD-2-Clause", "BSD-3-Clause",
                   "GPL-2.0-only", "GPL-3.0-or-later", "MIT"]
  head "git://git-annex.branchable.com/", branch: "master"

  livecheck do
    url "https://hackage.haskell.org/package/git-annex"
    regex(/href=.*?git-annex[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "8e996d475efacfc480f0c975fe63200c766bc68320f75614c70bea30327334c0"
    sha256 cellar: :any,                 arm64_sonoma:  "9946488a7b486e8813c28df66eb7bc2a306b9aa14dc3c299b44c2d50bbe57e4d"
    sha256 cellar: :any,                 arm64_ventura: "e392b5fb1a4daadd8b14cc1eaba9261bda0020378a1d882e5ac6ea26964679dc"
    sha256 cellar: :any,                 sonoma:        "1a738d9745d956ce78a7c4e6cd1441acc2fb50e4658d900db051a8ca01e97d24"
    sha256 cellar: :any,                 ventura:       "034935a7ab56c4af05c20444d43d80c6b53fc5ab39dd717520f0f2d03dc6d17a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e60f3de982dc3a27d7fce0d6e4b0a31da1458a4dc6d09ae05b51250a8c92c876"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4fc60868a993a15e75f4fbed39004766478d2d8464daa6a653fb6188fc40e046"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc@9.10" => :build
  depends_on "pkgconf" => :build
  depends_on "libmagic"

  uses_from_macos "zlib"

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args, "--flags=+S3 +Servant"
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
