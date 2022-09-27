class GitAnnex < Formula
  desc "Manage files with git without checking in file contents"
  homepage "https://git-annex.branchable.com/"
  url "https://hackage.haskell.org/package/git-annex-10.20220927/git-annex-10.20220927.tar.gz"
  sha256 "8cdeff4de54bd861949616ff1cb54338f87f7aa93e8297fe88e61dc25b530caf"
  license all_of: ["AGPL-3.0-or-later", "BSD-2-Clause", "BSD-3-Clause",
                   "GPL-2.0-only", "GPL-3.0-or-later", "MIT"]
  head "git://git-annex.branchable.com/", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "d72d6dbf6920ed894ac1195daa1a578175c28080c1dd71b24ff504fd8f740474"
    sha256 cellar: :any,                 arm64_big_sur:  "b945443cb717edbc49d1fe8504de60aeb6327da69aa9be887f058d308a608d3b"
    sha256 cellar: :any,                 monterey:       "7792c1317a32b49ecd6ca597bce7a661eacfba4e501ac0a71b22926c8738c0f8"
    sha256 cellar: :any,                 big_sur:        "1b9dc2498bf366d030f32c938ab7c69920b856bf0e2543dd13bd6cf2b3cbe15b"
    sha256 cellar: :any,                 catalina:       "6e41190b1f568fb733d52ae1b62e59df2131a73b9f2dfe97e0f9c47c9a1e632b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2f9cd758c626034a939fe3f9ebd0bce2677a3a07fe27bac31483b0c8ba784c7f"
  end

  depends_on "cabal-install" => :build
  depends_on "pkg-config" => :build
  depends_on "libmagic"

  on_arm do
    # An llc process leak in GHC 8.10 causes build to fail on ARM CI.
    # Since some `git-annex` Haskell dependencies don't cleanly build
    # with GHC 9.2+, we add workarounds to successfully build.
    #
    # Ref: https://github.com/Homebrew/homebrew-core/pull/99021
    depends_on "ghc" => :build

    resource "aws" do
      url "https://hackage.haskell.org/package/aws-0.22.1/aws-0.22.1.tar.gz"
      sha256 "c49a23513a113a2fa08bdb44c400182ae874171fbcbb4ee85da7e94c4870e87f"
    end

    resource "bloomfilter" do
      url "https://hackage.haskell.org/package/bloomfilter-2.0.1.0/bloomfilter-2.0.1.0.tar.gz"
      sha256 "6c5e0d357d5d39efe97ae2776e8fb533fa50c1c05397c7b85020b0f098ad790f"

      # Fix build with GHC 9.2
      # PR ref: https://github.com/bos/bloomfilter/pull/20
      patch do
        url "https://github.com/bos/bloomfilter/commit/fb79b39c44404fd791a3bed973e9d844fb084f1e.patch?full_index=1"
        sha256 "c91c45fbdeb92f9dcb9b55412d14603b4e480139f6638e8b6ed651acd92409f3"
      end
    end
  end
  on_intel do
    depends_on "ghc@8.10" => :build
  end

  def install
    # Add workarounds to build with GHC 9.2
    if Hardware::CPU.arm?
      (buildpath/"homebrew/aws").install resource("aws")
      (buildpath/"homebrew/bloomfilter").install resource("bloomfilter")

      # aws constraint bytestring<0.11 is not compatible with GHC 9.2
      inreplace buildpath/"homebrew/aws/aws.cabal", /( bytestring .*<) 0\.11,/, "\\1 0.12,"

      (buildpath/"cabal.project.local").write <<~EOS
        packages: .
                  homebrew/aws/
                  homebrew/bloomfilter/
      EOS
    end

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
