class GitAnnex < Formula
  desc "Manage files with git without checking in file contents"
  homepage "https://git-annex.branchable.com/"
  url "https://hackage.haskell.org/package/git-annex-10.20240227/git-annex-10.20240227.tar.gz"
  sha256 "18db118fbd0da08927f810080980e9189fe6c91b40c80d7de15722ad5d37fe1e"
  license all_of: ["AGPL-3.0-or-later", "BSD-2-Clause", "BSD-3-Clause",
                   "GPL-2.0-only", "GPL-3.0-or-later", "MIT"]
  head "git://git-annex.branchable.com/", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "8318d2548028d62b247a5900f985c243223c557a802da9712fd7f76eb5df85fd"
    sha256 cellar: :any,                 arm64_ventura:  "f360ad3b0686e8cfc07b9cf49d15b3215018b4ea6dce9b726fbc47bbf07cf146"
    sha256 cellar: :any,                 arm64_monterey: "8c27862f0fb81c50aceee8287c0b271a085ab67e8f0ab521caf2c9f44dd5f200"
    sha256 cellar: :any,                 sonoma:         "a9cd96feb01545efccb2a2281b49b5931a60162e6e49f2c4a6f0129b027f0770"
    sha256 cellar: :any,                 ventura:        "6cdb1e33c187196e8d6e9df79268430981c8e54fd356e39368c5289702b14c22"
    sha256 cellar: :any,                 monterey:       "01cca9c6d8db018fd85abdfc446cae3325048b7b7edfc5d3154dfb98c8a7c985"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5b016fc86c4434ccb7711588e6111d550703164e5fb466a3fbf84e096ad3b86c"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc@9.6" => :build
  depends_on "pkg-config" => :build
  depends_on "libmagic"

  def install
    # https://github.com/aristidb/aws/issues/288
    cabal_args = std_cabal_v2_args + ["--constraint=attoparsec-aeson<2.2.0.0"]
    system "cabal", "v2-update"
    system "cabal", "v2-install", *cabal_args, "--flags=+S3"
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
                 "webdav adb tahoe glacier ddar git-lfs httpalso borg hook external"

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
