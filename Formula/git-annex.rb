class GitAnnex < Formula
  desc "Manage files with git without checking in file contents"
  homepage "https://git-annex.branchable.com/"
  url "https://hackage.haskell.org/package/git-annex-10.20230126/git-annex-10.20230126.tar.gz"
  sha256 "f5b2c8561cf9085e1d0de0aba2215e7c6b50e2afb597c3263d3ff606a47d6519"
  license all_of: ["AGPL-3.0-or-later", "BSD-2-Clause", "BSD-3-Clause",
                   "GPL-2.0-only", "GPL-3.0-or-later", "MIT"]
  head "git://git-annex.branchable.com/", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "22e2b7373e0f2cbc30abb14939951e4a562dad481421bf09a5c753d9e9a4c732"
    sha256 cellar: :any,                 arm64_monterey: "8a04339f00b7c6be5b0a1f62eb19afdebd9be1d8182f47785fa475e40751051d"
    sha256 cellar: :any,                 arm64_big_sur:  "2058fae6769234a04dc8634309e539b9dd9869083ec16c0c04a304aaffb5b91d"
    sha256 cellar: :any,                 ventura:        "6bd394548ba9249602227840f21a79dacc9c0190bcdc97ccff7c53e5c341c2d6"
    sha256 cellar: :any,                 monterey:       "406f2168b4e3095577d68dac2507a788a2185860ea765fccc9768b41d018a533"
    sha256 cellar: :any,                 big_sur:        "4f8531331f25157784fc59a509d4eb032446a025744875bd37747d91e7856986"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d9e8e09a86df6b8082236a94399f8c88b1c037f13ea4c99606cc8c870afb9aff"
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
