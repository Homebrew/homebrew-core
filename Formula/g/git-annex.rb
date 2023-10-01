class GitAnnex < Formula
  desc "Manage files with git without checking in file contents"
  homepage "https://git-annex.branchable.com/"
  url "https://hackage.haskell.org/package/git-annex-10.20230828/git-annex-10.20230828.tar.gz"
  sha256 "0b3469d932f0d8f133d79b3b8efc770d95e7db74f99c14679b494bdec840665d"
  license all_of: ["AGPL-3.0-or-later", "BSD-2-Clause", "BSD-3-Clause",
                   "GPL-2.0-only", "GPL-3.0-or-later", "MIT"]
  head "git://git-annex.branchable.com/", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "3a4436b154f1e297ab91f723cfb3345af53f02a28a9a4423f46a0178d693dccf"
    sha256 cellar: :any,                 arm64_monterey: "01dad904f4ca26cb4d4b12e978b23c132adfc2e722e58089a911280fff8e6337"
    sha256 cellar: :any,                 arm64_big_sur:  "847de59f53263aad6ebdcb66aa5c21eeaadcef1db5ecd1e1eb7dfee056051c52"
    sha256 cellar: :any,                 ventura:        "c04b13f2dbfefb77605bac158f9992102e387f48a02656b17307c04b32371f1c"
    sha256 cellar: :any,                 monterey:       "6d65196be8f4d285174dac461f1a06c40ab88035b82e1dbab25ec899d3bc7797"
    sha256 cellar: :any,                 big_sur:        "5f2edea91ba0bc7d1721521a8e7e012440db1ea56dcd686789289ae10be5110d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "90208bddfa4e31a88d3f3febe02ee7c75ffe2b3752de0497428494eb02731278"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
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
