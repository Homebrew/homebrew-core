class GitAnnex < Formula
  desc "Manage files with git without checking in file contents"
  homepage "https://git-annex.branchable.com/"
  url "https://hackage.haskell.org/package/git-annex-10.20231227/git-annex-10.20231227.tar.gz"
  sha256 "6e281669e1a3219c7d7122e2faf43652edf8bdba76c0d9c667764b71794d922b"
  license all_of: ["AGPL-3.0-or-later", "BSD-2-Clause", "BSD-3-Clause",
                   "GPL-2.0-only", "GPL-3.0-or-later", "MIT"]
  head "git://git-annex.branchable.com/", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "7cf5d20131c0bf7ca73cb917e07803881d6fafdb05283a75e8622ea84b6f3596"
    sha256 cellar: :any,                 arm64_ventura:  "c8cc606a79549f1d23f836d5f3e2216a768a0e71998453e99c18d822789cf49c"
    sha256 cellar: :any,                 arm64_monterey: "cd9af16f8729ed5a99f97604717428619c7ced6a79bf4bd91f4dcb895dc9199e"
    sha256 cellar: :any,                 sonoma:         "89cad1b63c434cbbc4118b3b8efa104d2edf7414fc0a9c975777a75c11e7d4dd"
    sha256 cellar: :any,                 ventura:        "f62b8cc65b4c86810ef8c706c3d7ea826fdfdbbb59531fc2c6229bc6edfb5abc"
    sha256 cellar: :any,                 monterey:       "b367f4e466f3c8f1c816f62322ac1c968d72478212ed7e8c4ad39a3a13305826"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8876554feda0f79413a20412910de301776ec1034db48b8f59bb780f06dc409e"
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
