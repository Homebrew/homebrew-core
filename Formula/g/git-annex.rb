class GitAnnex < Formula
  desc "Manage files with git without checking in file contents"
  homepage "https://git-annex.branchable.com/"
  url "https://hackage.haskell.org/package/git-annex-10.20250115/git-annex-10.20250115.tar.gz"
  sha256 "d1c0b27ba44be4a8d615280cd16652fd8cb1d7bd6ec44ba938bea01886d259d4"
  license all_of: ["AGPL-3.0-or-later", "BSD-2-Clause", "BSD-3-Clause",
                   "GPL-2.0-only", "GPL-3.0-or-later", "MIT"]
  head "git://git-annex.branchable.com/", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "0d5776c0fb0d8193b6e99b6a7ce2b2e7e90d3a45f1a13d8a4d781d0a39a6ccf3"
    sha256 cellar: :any,                 arm64_sonoma:  "06ea1127f166d6df56756e4e8d6de96a34c4f61b053fdeb2aacd4c73e55949eb"
    sha256 cellar: :any,                 arm64_ventura: "67dc9732b712eb582e33669ec096a5a5f8ed524d809fcb0a6cfb3ac2dc924eca"
    sha256 cellar: :any,                 sonoma:        "cf60527f07dbcf2a8b8ee21aaa9946135a2efe32a89f34b06609adfbc44b27d6"
    sha256 cellar: :any,                 ventura:       "ba7089a613b7deab09ef54895e37ea07156e3bd37afe354a672907002737e994"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "089aa7235fa114d018d77150a31d48df50f7fec0dc750c82f9e40246efefedab"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc@9.8" => :build
  depends_on "pkgconf" => :build
  depends_on "libmagic"

  uses_from_macos "zlib"

  def install
    system "cabal", "v2-update"
    # Work around https://github.com/yesodweb/yesod/issues/1854 with constraint
    # TODO: Remove once fixed upstream
    system "cabal", "v2-install", *std_cabal_v2_args, "--flags=+S3", "--constraint=wai-extra<3.1.17"
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
