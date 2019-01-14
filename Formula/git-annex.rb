require "language/haskell"

class GitAnnex < Formula
  include Language::Haskell::Cabal

  desc "Manage files with git without checking in file contents"
  homepage "https://git-annex.branchable.com/"
  url "https://hackage.haskell.org/package/git-annex-7.20181121/git-annex-7.20181121.tar.gz"
  sha256 "d044f0557cc85ed664423ed5bc20e767bd796f6ffd32d3bf39b8a59cc7b7cb1d"
  head "git://git-annex.branchable.com/"

  bottle do
    sha256 "2dd3ed2ba23afc4a47ce43dd0ef88c17691ec03f5cfd9c0fc851f77345b4eeca" => :mojave
    sha256 "dc077598afef126a61fba944aef799de03f91799f0975921c8097d0c7f1c56d1" => :high_sierra
    sha256 "581d2b1ab2b844f9f87da719898e513e77c9f4cee1d1e36a7ab0e944e5592029" => :sierra
  end

  depends_on "cabal-install" => :build
  depends_on "ghc@8.2" => :build
  depends_on "pkg-config" => :build
  depends_on "gsasl"
  depends_on "libmagic"
  depends_on "quvi"
  depends_on "xdot"

  def install
    # Reported 28 Feb 2018 to aws upstream https://github.com/aristidb/aws/issues/244
    # This is already resolved in aws 0.20 but we can't move to 0.20 until
    # esqueleto 2.6.0 ships. See https://github.com/bitemyapp/esqueleto/issues/88
    # The network 2.7.0.1 issue has been fixed upstream but needs a new release.
    install_cabal_package "--constraint", "http-conduit<2.3",
                          "--constraint", "network<2.7.0.1",
                          :using => ["alex", "happy", "c2hs"],
                          :flags => ["s3", "webapp"]
    bin.install_symlink "git-annex" => "git-annex-shell"
  end

  plist_options :manual => "git annex assistant --autostart"

  def plist; <<~EOS
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>RunAtLoad</key>
        <true/>
        <key>KeepAlive</key>
        <false/>
        <key>ProgramArguments</key>
        <array>
          <string>#{opt_bin}/git-annex</string>
          <string>assistant</string>
          <string>--autostart</string>
        </array>
      </dict>
    </plist>
  EOS
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
