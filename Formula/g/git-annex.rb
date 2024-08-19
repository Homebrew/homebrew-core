class GitAnnex < Formula
  desc "Manage files with git without checking in file contents"
  homepage "https://git-annex.branchable.com/"
  url "https://hackage.haskell.org/package/git-annex-10.20240808/git-annex-10.20240808.tar.gz"
  sha256 "c5b5abf695d9b95762c5aa29de87ef183800678191456d27c51fed79089e2315"
  license all_of: ["AGPL-3.0-or-later", "BSD-2-Clause", "BSD-3-Clause",
                   "GPL-2.0-only", "GPL-3.0-or-later", "MIT"]
  head "git://git-annex.branchable.com/", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "4b73a83093b686865860bbc96aedca8e4dd8aa466524a4890ce91df1bd6e7c97"
    sha256 cellar: :any,                 arm64_ventura:  "7d755c50e923531dd43c411703a16097211d7b3fb1c0e37cff6109dc5571c7eb"
    sha256 cellar: :any,                 arm64_monterey: "2666b3ca9caba231ce84c9b59ce5bcaff15d383fcdd686e493903ab6a429cb95"
    sha256 cellar: :any,                 sonoma:         "6ca922d9b3b1b7621dc57b6d2008867a5e060348d86a10046d10d45c24772813"
    sha256 cellar: :any,                 ventura:        "ea5500fb0e9404e01c6db12efd6f98bfac60aaea1721ac3570cdf4613916ed08"
    sha256 cellar: :any,                 monterey:       "c606b3aedd1287e6dd3a813626398daeaef41cf00f1fc27db673ae054be08990"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8f359aac5a6e1a6d112ea4a68e4b64f91a9a168466b0b82ac33f383da71cff98"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc@9.8" => :build
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
