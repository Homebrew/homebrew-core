require "language/haskell"

class GitAnnex < Formula
  include Language::Haskell::Cabal

  desc "Manage files with git without checking in file contents"
  homepage "https://git-annex.branchable.com/"
  url "https://hackage.haskell.org/package/git-annex-6.20171003/git-annex-6.20171003.tar.gz"
  sha256 "51edd74b98cbf5baa38e2197fb60b8b04d8cc375a686859ee74cb5e54a53de3b"
  head "git://git-annex.branchable.com/"

  bottle do
    sha256 "14506f7f7538daa7395484890b860441ce3a390c81e6c7ed58fd6669fd215a7f" => :high_sierra
    sha256 "0d04414621e85f62e2826b4abc00322b4ab638d6fbce1e08d8e445d34dfeb701" => :sierra
    sha256 "f7587ce10d93624d4c7ab3983c93309aae2cb799fb96b7ef881aba3a040aa134" => :el_capitan
  end

  option "with-git-union-merge", "Build the git-union-merge tool"

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "pkg-config" => :build
  depends_on "gsasl"
  depends_on "libmagic"
  depends_on "quvi"
  depends_on "xdot" => :recommended

  def install
    # The fingertree constraint can be removed after the next release of reducers (>v3.12.1)
    # https://git-annex.branchable.com/bugs/fingertree___62____61___0.1.2_causes_build_to_fail_on_reducers/
    # git-annex is broken with aws 0.17, error: "Couldn't match expected type 'AWS.Configuration'"
    # https://git-annex.branchable.com/bugs/Cannot_build_with_aws_0.17.1/
    install_cabal_package "--constraint", "fingertree<0.1.2.0", "--constraint", "aws<0.17",
                          "--allow-newer=aws:time", :using => ["alex", "happy", "c2hs"],
                                                    :flags => ["s3", "webapp"] do
      # this can be made the default behavior again once git-union-merge builds properly when bottling
      if build.with? "git-union-merge"
        system "make", "git-union-merge", "PREFIX=#{prefix}"
        bin.install "git-union-merge"
        system "make", "git-union-merge.1", "PREFIX=#{prefix}"
      end
    end
    bin.install_symlink "git-annex" => "git-annex-shell"
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
    assert_match "add Hello.txt ok", shell_output("git annex add .")
    system "git", "commit", "-a", "-m", "Initial Commit"
    assert File.symlink?("Hello.txt")

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
