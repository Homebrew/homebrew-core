class GitAnnex < Formula
  desc "Manage files with git without checking in file contents"
  homepage "https://git-annex.branchable.com/"
  url "https://hackage.haskell.org/package/git-annex-10.20220127/git-annex-10.20220127.tar.gz"
  sha256 "5c58d5238f29487df45759a0a7f424ecc27131a6a234634b16d6b2909403481b"
  license all_of: ["AGPL-3.0-or-later", "BSD-2-Clause", "BSD-3-Clause",
                   "GPL-2.0-only", "GPL-3.0-or-later", "MIT"]
  head "git://git-annex.branchable.com/", branch: "master"

  bottle do
    sha256 cellar: :any,                 monterey:     "f8221a669cbe8dbb0d4e8df022be5803a4aec20c6881cec64c42b41e277f5e7b"
    sha256 cellar: :any,                 big_sur:      "dc3dcca57c906471cfa717ca0555b858ab382a6d4f104ce1584fcbb54c106b72"
    sha256 cellar: :any,                 catalina:     "00be8997746cc257d5aeeed2aadcd8c9cb44d00c9c555feee0b44d6ee2364649"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "87bc237adb3cf2c16dd18bee968085386038e5e2bf148800972fa2322607f872"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "pkg-config" => :build
  depends_on "gsasl"
  depends_on "libmagic"
  depends_on "quvi"

  def install
    system "cabal", "v2-update"
    args = ["--flags=+S3"]

    # Workaround for:
    # ghc: could not execute: opt
    # ghc: could not execute: llc
    # FIXME: This shouldn't be needed since we wrap `ghc` in an env script on ARM.
    if Hardware::CPU.arm?
      llvm = Formula["ghc"].deps
                           .find { |d| d.name.match?(/^llvm(@\d+)?$/) }
                           .to_formula

      args << "--extra-prog-path=#{llvm.opt_bin}"
      args << "--verbose=3"

      ENV["LLC"] = (llvm.opt_bin/"llc").to_s
      ENV["OPT"] = (llvm.opt_bin/"opt").to_s
      ENV.append "PATH", llvm.opt_bin.to_s
    end

    system "cabal", "v2-install", *std_cabal_v2_args, *args
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
