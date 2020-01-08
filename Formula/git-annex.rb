require "language/haskell"

class GitAnnex < Formula
  include Language::Haskell::Cabal

  desc "Manage files with git without checking in file contents"
  homepage "https://git-annex.branchable.com/"
  url "https://hackage.haskell.org/package/git-annex-7.20191230/git-annex-7.20191230.tar.gz"
  sha256 "227c9e7dd7fdf32398a3edaec418550c96d3e55cb05f012566f38f1de1264df7"
  head "git://git-annex.branchable.com/"

  bottle do
    cellar :any
    sha256 "d8574cec7e255e94a1fd3a2a42b05b4aa3802c25ff9452a9454ad10d124a3bbb" => :catalina
    sha256 "c5e4e1242efb274e7036984c08165b71016a4735a92c96c2189debc3814d4ba5" => :mojave
    sha256 "405814f5c8b37d26bea3ad4947a0fbbd18ac4efa8038b09b5684a7a496162dea" => :high_sierra
  end

  depends_on "cabal-install" => :build
  depends_on "ghc@8.6" => :build
  depends_on "pkg-config" => :build
  depends_on "gsasl"
  depends_on "libmagic"
  depends_on "quvi"
  depends_on "xdot"

  def install
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
