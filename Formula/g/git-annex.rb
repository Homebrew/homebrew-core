class GitAnnex < Formula
  desc "Manage files with git without checking in file contents"
  homepage "https://git-annex.branchable.com/"
  url "https://hackage.haskell.org/package/git-annex-10.20240129/git-annex-10.20240129.tar.gz"
  sha256 "e0e5ba6f27746679262634700d9160a9a75b071cda4a8089c2405f3c55cf8339"
  license all_of: ["AGPL-3.0-or-later", "BSD-2-Clause", "BSD-3-Clause",
                   "GPL-2.0-only", "GPL-3.0-or-later", "MIT"]
  head "git://git-annex.branchable.com/", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "63baac827f6647ae02db624b55498a3c2341cf2af939e97fe9e7c3b6738ab190"
    sha256 cellar: :any,                 arm64_ventura:  "62e25fd913225b76467ba2d5b413855f2903eaacee82e53e0131bbc142e390c7"
    sha256 cellar: :any,                 arm64_monterey: "aa6d6df8f03c19e70a6b2bd4abef74a0d6a06932bb0ff2bb74a7fdaa24650179"
    sha256 cellar: :any,                 sonoma:         "a489239ae6acd5e49e46c71644f593e50492bf6a56803cc1375d5ad6575cae64"
    sha256 cellar: :any,                 ventura:        "dbf599fb9130d2553b2784e60a5df780aa2ffcc40b3732b8642ff8e5390daf14"
    sha256 cellar: :any,                 monterey:       "6ad99eceb11d1c887e70a447ace2758f1e76038f4ea72d773a94a2567ce591a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5f0cbadc15ec4724d6c4a77a40171ee41b9179959fe44ab0b53851e635ad638f"
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
