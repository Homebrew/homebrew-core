class GitAnnex < Formula
  desc "Manage files with git without checking in file contents"
  homepage "https://git-annex.branchable.com/"
  url "https://hackage.haskell.org/package/git-annex-10.20230214/git-annex-10.20230214.tar.gz"
  sha256 "a2057d28b53e830f2673fe0bef702306ad175edecd16d3983cdd4dda0f8db482"
  license all_of: ["AGPL-3.0-or-later", "BSD-2-Clause", "BSD-3-Clause",
                   "GPL-2.0-only", "GPL-3.0-or-later", "MIT"]
  head "git://git-annex.branchable.com/", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "25041bb33591987cca1a2d1c9970dffac67c278a20117f3bfc29b56201f8886c"
    sha256 cellar: :any,                 arm64_monterey: "be5442f584daa581e9c57d1973ce379b54ec874e431989c1409d3c0e95f50e35"
    sha256 cellar: :any,                 arm64_big_sur:  "3c60c460001eb127c7e386f1b494535d1ff50db858a8ba407bb3af7e5e4e80d2"
    sha256 cellar: :any,                 ventura:        "28d71bd501cabafe9d4ed92e25a0b9816c23829747bc223b9cc28e775f8e67f4"
    sha256 cellar: :any,                 monterey:       "16ca5492cfdc963ff9ee7fa1ebfe0d6660da8733d43ed13eeefdde4bbd60d342"
    sha256 cellar: :any,                 big_sur:        "53d6a38d01bf1c606a7b206b6b1edb8066864c85bdb71091f35abeced6242f7a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e36ecfeffb58845e16027cb5f9d5bfdc98fa54f409a5f61d91491a9004339f58"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "pkg-config" => :build
  depends_on "libmagic"

  resource "bloomfilter" do
    url "https://hackage.haskell.org/package/bloomfilter-2.0.1.0/bloomfilter-2.0.1.0.tar.gz"
    sha256 "6c5e0d357d5d39efe97ae2776e8fb533fa50c1c05397c7b85020b0f098ad790f"

    # Fix build with GHC >= 9.2
    # PR ref: https://github.com/bos/bloomfilter/pull/20
    patch do
      url "https://github.com/bos/bloomfilter/commit/fb79b39c44404fd791a3bed973e9d844fb084f1e.patch?full_index=1"
      sha256 "c91c45fbdeb92f9dcb9b55412d14603b4e480139f6638e8b6ed651acd92409f3"
    end
  end

  def install
    # Add workarounds to build with GHC >= 9.2
    (buildpath/"homebrew/bloomfilter").install resource("bloomfilter")
    (buildpath/"cabal.project.local").write <<~EOS
      packages: ./*.cabal
                homebrew/bloomfilter/
    EOS

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
    # We don't want this here or it gets "caught" by git-annex.
    rm_r "Library/Python/2.7/lib/python/site-packages/homebrew.pth"

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
