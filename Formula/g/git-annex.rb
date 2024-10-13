class GitAnnex < Formula
  desc "Manage files with git without checking in file contents"
  homepage "https://git-annex.branchable.com/"
  url "https://hackage.haskell.org/package/git-annex-10.20240927/git-annex-10.20240927.tar.gz"
  sha256 "33e91e08b9eeb87e58288f9a24d7472bda74899837bfafced60c2f6b3573d684"
  license all_of: ["AGPL-3.0-or-later", "BSD-2-Clause", "BSD-3-Clause",
                   "GPL-2.0-only", "GPL-3.0-or-later", "MIT"]
  head "git://git-annex.branchable.com/", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "7d6986beaa3d8aab3d2913738df947b8fc6bd4e7baf985c04361f34f8d4cfab4"
    sha256 cellar: :any,                 arm64_sonoma:  "3f3a09bdda26ba5fc5af8fdc47968043c6e390ae4b56078f60df0b5edc7222a4"
    sha256 cellar: :any,                 arm64_ventura: "a119f44590aaa1eaa48da06c7beb7acd3e33e4ad479add9230d1e55cf788c84a"
    sha256 cellar: :any,                 sonoma:        "cf3dc3421582ffb0686e784536cbc448cef73e431fe75e2099fe9c5ad4ccc9b4"
    sha256 cellar: :any,                 ventura:       "092879b50809267145d8855bb82224fa0f8d41675ffd5d2ffb45558834cbe283"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e6d1ed736d215c3e0885928d4742bb1a6b61d096a5459ceaa45b5fd823e9e606"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc@9.8" => :build
  depends_on "pkg-config" => :build
  depends_on "libmagic"

  uses_from_macos "zlib"

  def install
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
                 "webdav adb tahoe glacier ddar git-lfs httpalso borg rclone hook external"

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
