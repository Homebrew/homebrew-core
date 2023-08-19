class GitAnnex < Formula
  desc "Manage files with git without checking in file contents"
  homepage "https://git-annex.branchable.com/"
  url "https://hackage.haskell.org/package/git-annex-10.20230802/git-annex-10.20230802.tar.gz"
  sha256 "c7e89ced9dcb9516d924fe7bc4a41fead795a5538939c7ef19b0fbf3f8607217"
  license all_of: ["AGPL-3.0-or-later", "BSD-2-Clause", "BSD-3-Clause",
                   "GPL-2.0-only", "GPL-3.0-or-later", "MIT"]
  head "git://git-annex.branchable.com/", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8bbbf4d6bcbf25e6aa6df6418c5c8505b9edce7da8a97b01dd52431bee798301"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a5fbadcb20c3408d6b379cab77e3677fe38b3a7a8d032b1dc87d24679b613b01"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "077e4b5b731cc56b633ac1df9f546ac0761719832dcadf891c0f17da71d89def"
    sha256 cellar: :any_skip_relocation, ventura:        "d7e3e5df37e4fb7f9fb79388e7fc87244525cd3566debcb854001a2ad8329d4d"
    sha256 cellar: :any_skip_relocation, monterey:       "7f77c924f64abcf8a40c2ddbce6a08ea3204a9abb8c22ea4a6da5800a780639b"
    sha256 cellar: :any_skip_relocation, big_sur:        "ace357e4217c0d6acf143726e363fa91823bf49b964be649ff8f39c1b2ca0af1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "28bf18d857c39bea3d5b2543ce6cd0892c2d2d7e6c0100fd57b0aeb6b4237ae5"
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
