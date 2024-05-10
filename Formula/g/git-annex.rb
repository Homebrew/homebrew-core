class GitAnnex < Formula
  desc "Manage files with git without checking in file contents"
  homepage "https://git-annex.branchable.com/"
  url "https://hackage.haskell.org/package/git-annex-10.20240430/git-annex-10.20240430.tar.gz"
  sha256 "4093dc11bf3c49186fc46d817da848ab3aa019625fb183c29dd6ccd7197362dc"
  license all_of: ["AGPL-3.0-or-later", "BSD-2-Clause", "BSD-3-Clause",
                   "GPL-2.0-only", "GPL-3.0-or-later", "MIT"]
  head "git://git-annex.branchable.com/", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "4efb9e7ee3c63a77f07b299d271f4f5de446fdaa0e55357864ded9b375130cad"
    sha256 cellar: :any,                 arm64_ventura:  "67bcbc3ea56568dda652fbbc87eea994e0c49beb03a873a418aa2f0a8668b3b8"
    sha256 cellar: :any,                 arm64_monterey: "4db444ed662431b258edadb0ee95a70046ca1039443931091e8630b4fd1794cc"
    sha256 cellar: :any,                 sonoma:         "324e308c621de5e9faf81ea427b4ee69b6285391359dcf8edc3411dd047a481c"
    sha256 cellar: :any,                 ventura:        "18e3545e6f969bcccc529c048e72bdba05fb6492f3349fba471a88f3c35aaae1"
    sha256 cellar: :any,                 monterey:       "9700d6c06b4f94df88e4fed27d8467515e3eaa3d8993dd82cdd4972ace70f6ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "82b18139f3edcad064f3a7ab358b0d4e9a1312332bf3b170aa2abb8aa5a9da95"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc@9.6" => :build
  depends_on "pkg-config" => :build
  depends_on "libmagic"

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args, "--flags=+S3"
    bin.install_symlink "git-annex" => "git-annex-shell"
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
    assert !File.symlink?("Hello.txt")
    assert_match(/^add Hello.txt.*ok.*\(recording state in git\.\.\.\)/m, shell_output("git annex add ."))
    system "git", "commit", "-a", "-m", "Initial Commit"
    assert File.symlink?("Hello.txt")

    # make sure the various remotes were built
    assert_match shell_output("git annex version | grep 'remote types:'").chomp,
                 "remote types: git gcrypt p2p S3 bup directory rsync web bittorrent " \
                 "webdav adb tahoe glacier ddar git-lfs httpalso borg rclone hook external"

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
