require "language/haskell"

class GitAnnex < Formula
  include Language::Haskell::Cabal

  desc "Manage files with git without checking in file contents"
  homepage "https://git-annex.branchable.com/"
  url "https://hackage.haskell.org/package/git-annex-6.20161118/git-annex-6.20161118.tar.gz"
  sha256 "84d83b41ce671b29f7c718979bb06d2bb3e3a3f3a3536257f3c6a3da993e47ba"
  head "git://git-annex.branchable.com/"

  bottle do
    cellar :any
    rebuild 1
    sha256 "12d434ff3347440a541b8dafc8e6fb99edc952a00715defa51e7f2713f29c9b9" => :sierra
    sha256 "0f6459e5ac5df69e01e97a182c3d842a3b9ae5bb40fc4447ceb081db12b73723" => :el_capitan
    sha256 "49f296bab9478dd2b3603bd645ab8dcae60a8df45297def78da443805dfba086" => :yosemite
  end

  option "with-git-union-merge", "Build the git-union-merge tool"

  depends_on "ghc" => :build
  depends_on "cabal-install" => :build
  depends_on "pkg-config" => :build
  depends_on "gsasl"
  depends_on "libidn"
  depends_on "libmagic"
  depends_on "gnutls"
  depends_on "quvi"
  depends_on "xdot" => :recommended

  resource "esqueleto-2.4.3" do
    url "https://mirrors.ocf.berkeley.edu/debian/pool/main/h/haskell-esqueleto/haskell-esqueleto_2.4.3.orig.tar.gz"
    mirror "https://mirrors.kernel.org/debian/pool/main/h/haskell-esqueleto/haskell-esqueleto_2.4.3.orig.tar.gz"
    sha256 "bf555cfb40519ed1573f7bb90c65f693b9639dfa93fc2222230d3ded6e897434"
  end

  # Patch for esqueleto to be able to use persistent 2.6
  # https://github.com/joeyh/git-annex/commit/6416ae9c09f54c062c05cc686ade35c2e08c1434
  # https://github.com/haskell-infra/hackage-trustees/issues/84
  # https://github.com/prowdsponsor/esqueleto/issues/137
  resource "esqueleto-newer-persistent-patch" do
    url "https://mirrors.ocf.berkeley.edu/debian/pool/main/h/haskell-esqueleto/haskell-esqueleto_2.4.3-5.debian.tar.xz"
    mirror "https://mirrors.kernel.org/debian/pool/main/h/haskell-esqueleto/haskell-esqueleto_2.4.3-5.debian.tar.xz"
    sha256 "b152307e6c8f5f79d070bcadcf05d32c52a205bd2bacc578686c2aa01491aff6"
  end

  def install
    # use `xdot` instead of `dot -Tx11` to display generated maps
    inreplace "Command/Map.hs" do |s|
      s.gsub! "dot", "xdot"
      # eliminate extra parameter in actual invocation
      s.gsub! "Param \"-Tx11\",", ""
      # change status message
      s.gsub! "-Tx11", ""
    end

    cabal_sandbox do
      (buildpath/"esqueleto-2.4.3").install resource("esqueleto-2.4.3")
      resource("esqueleto-newer-persistent-patch").stage do
        system "patch", "-p1", "-i", Pathname.pwd/"patches/newer-persistent",
                        "-d", buildpath/"esqueleto-2.4.3"
      end
      cabal_sandbox_add_source "esqueleto-2.4.3"
      install_cabal_package :using => ["alex", "happy", "c2hs"], :flags => ["s3", "webapp"] do
        # this can be made the default behavior again once git-union-merge builds properly when bottling
        if build.with? "git-union-merge"
          system "make", "git-union-merge", "PREFIX=#{prefix}"
          bin.install "git-union-merge"
          system "make", "git-union-merge.1", "PREFIX=#{prefix}"
        end
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
