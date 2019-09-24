require "language/haskell"

class GitAnnex < Formula
  include Language::Haskell::Cabal

  desc "Manage files with git without checking in file contents"
  homepage "https://git-annex.branchable.com/"
  url "https://hackage.haskell.org/package/git-annex-7.20190912/git-annex-7.20190912.tar.gz"
  sha256 "9b25fba7de61ce5f09e737873442cd5702d01908b10430343a5b8cce0add72a8"
  head "git://git-annex.branchable.com/"

  bottle do
    cellar :any
    sha256 "3461db6b82bdfa01ff3079a9389822abf997bca5547c16dcf911ef53c4a7de34" => :mojave
    sha256 "719ad81c1fa318a1f0fd79f2a3801086931a142715ff965638fc0752667e0f37" => :high_sierra
    sha256 "d2c25f2af71d468fc3c310592b0111315cd4573f82f586a4dd93c8962aec5365" => :sierra
  end

  depends_on "cabal-install" => :build
  depends_on "ghc@8.6" => :build
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
    install_cabal_package "--constraint", "http-conduit>=2.3",
                          "--constraint", "network>=2.6.3.0",
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
    assert_match /^add Hello.txt.*ok.*\(recording state in git\.\.\.\)/m, shell_output("git annex add .")
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
