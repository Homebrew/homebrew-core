class GitAnnexRemoteRclone < Formula
  desc "Use rclone supported cloud storage with git-annex"
  homepage "https://github.com/DanielDent/git-annex-remote-rclone"
  url "https://github.com/DanielDent/git-annex-remote-rclone/archive/v0.6.tar.gz"
  sha256 "fb9bb77c6dd30dad4966926af87f63be92ef442cfeabcfd02202c657f40439d0"
  license "GPL-3.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "3cc09391797c0e451e94b4b5cf7b909e4fdb834fe7d0dc321c42572c41c39279"
  end

  depends_on "git-annex"
  depends_on "rclone"

  def install
    bin.install "git-annex-remote-rclone"
  end

  test do
    # try a test modeled after git-annex.rb's test (copy some lines
    # from there)

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

    ENV["RCLONE_CONFIG_TMPLOCAL_TYPE"]="local"
    system "git", "annex", "initremote", "testremote", "type=external", "externaltype=rclone",
                  "target=tmplocal", "encryption=none", "rclone_layout=lower"

    system "git", "annex", "copy", "Hello.txt", "--to=testremote"

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
