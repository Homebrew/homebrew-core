require "language/haskell"

class GitAnnex < Formula
  include Language::Haskell::Cabal

  desc "Manage files with git without checking in file contents"
  homepage "https://git-annex.branchable.com/"
  url "https://hackage.haskell.org/package/git-annex-6.20181011/git-annex-6.20181011.tar.gz"
  sha256 "ee319b305b9279cd11fd5da08882d62cf533a577243c3a37a4cda55766de284c"
  head "git://git-annex.branchable.com/"

  bottle do
    sha256 "3de536085890f16136d8f95ca8328b07d9d8e1a64e31c51ea64c4866887b96eb" => :mojave
    sha256 "0dec2e07b446289426b35e90d288fb50ceb305ef6fb37221df4255e4a69d4280" => :high_sierra
    sha256 "e14e425f71603482458acc3a98ba4031d81ef7a37276e8bdcc22c28bd468e0af" => :sierra
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
