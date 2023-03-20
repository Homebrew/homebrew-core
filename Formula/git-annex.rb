class GitAnnex < Formula
  desc "Manage files with git without checking in file contents"
  homepage "https://git-annex.branchable.com/"
  url "https://hackage.haskell.org/package/git-annex-10.20230227/git-annex-10.20230227.tar.gz"
  sha256 "f1ddf6a2d7a6f4c05a79014124e159ec5cc110e6dba509b54eea67f686e9960d"
  license all_of: ["AGPL-3.0-or-later", "BSD-2-Clause", "BSD-3-Clause",
                   "GPL-2.0-only", "GPL-3.0-or-later", "MIT"]
  head "git://git-annex.branchable.com/", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "a7d3027a38bba076b64da7311bec966f43a74db73ce39987e98035377789ac0f"
    sha256 cellar: :any,                 arm64_monterey: "6c55b7ba93b7202bbe4820debc96f5d56fd39a7ac3dd05fe171922a32e137277"
    sha256 cellar: :any,                 arm64_big_sur:  "038afdeabf523ca229f9ac7c237bb230b5383d738c9a74bef924694ece5165bd"
    sha256 cellar: :any,                 ventura:        "ee565b686b7f58cce753517fb05f9e240c83dc407f47e065d138bc2f67f3765e"
    sha256 cellar: :any,                 monterey:       "a0b94c22835a0fb7514a74613e1b2ad1fe646b9c5bc437b188dd15c7c43769b2"
    sha256 cellar: :any,                 big_sur:        "7f62fde3a17dfa025c1a2916e34ff80542714cadb87ec7a91647c101a9b3d1a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d89ee19ba34ae2735e14fb2f51f5c72fffc27aa0cba012f3cf97cb8db6b60226"
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
