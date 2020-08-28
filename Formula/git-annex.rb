class GitAnnex < Formula
  desc "Manage files with git without checking in file contents"
  homepage "https://git-annex.branchable.com/"
  url "https://hackage.haskell.org/package/git-annex-8.20200810/git-annex-8.20200810.tar.gz"
  sha256 "e631c9d52e440f80e9d305c95a078dcae71f200125bca91e49d5b8e2d864c6f3"
  head "git://git-annex.branchable.com/"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any
    sha256 "b2da7a293056e721b82cd6cfbc706203611321677ae78f084d24531df3423b04" => :catalina
    sha256 "cb3c028e6f987813c02dd7d1e3382721896ddfce92924776d3715e1912323766" => :mojave
    sha256 "969571512b9bbf02b5e1492a0b36501b8d3050e1c243c322accfc18eeba4dbe2" => :high_sierra
  end

  depends_on "cabal-install" => :build
  depends_on "ghc@8.6" => :build
  depends_on "pkg-config" => :build
  depends_on "gsasl"
  depends_on "libmagic"
  depends_on "quvi"

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args
    bin.install_symlink "git-annex" => "git-annex-shell"
  end

  plist_options manual: "git annex assistant --autostart"

  def plist
    <<~EOS
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
