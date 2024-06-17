class GitAnnex < Formula
  desc "Manage files with git without checking in file contents"
  homepage "https://git-annex.branchable.com/"
  url "https://hackage.haskell.org/package/git-annex-10.20240531/git-annex-10.20240531.tar.gz"
  sha256 "ca6a8d2e30a8140c2b65fe3b62ef716e911479839673dc3804135271e2ee7239"
  license all_of: ["AGPL-3.0-or-later", "BSD-2-Clause", "BSD-3-Clause",
                   "GPL-2.0-only", "GPL-3.0-or-later", "MIT"]
  head "git://git-annex.branchable.com/", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "e3aae6dc74428a277f3e93f60513a9abc494d7a6938d69bb37315cee91a452ae"
    sha256 cellar: :any,                 arm64_ventura:  "9f1ae18f8aef3cc69eed430d0f77f67be61d48066da7839d0263a1245cac1039"
    sha256 cellar: :any,                 arm64_monterey: "b9fe6a52bc58c95dfa33f56f990618f1446ea91c3fd062a83230d7b61d713ac9"
    sha256 cellar: :any,                 sonoma:         "2813cb88e626f6a044a1907a6fbc9ff8b8de48b5a020d98fe1df242d9c5248c2"
    sha256 cellar: :any,                 ventura:        "82a1f99f4e5badf07708ecaed4d0f638a8d8fedf47b97be8f351a6a41a75f614"
    sha256 cellar: :any,                 monterey:       "6cb449432e1a52af1ea80accff0a6da8fdd2991748a1946467bfb2e459093edf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "472badee032406aa8b6d8ae8f9b080d69075b78d41aa42b9a09a5c18921a6808"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc@9.6" => :build
  depends_on "pkg-config" => :build
  depends_on "libmagic"

  uses_from_macos "zlib"

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
