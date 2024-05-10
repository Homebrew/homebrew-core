class Gitwatch < Formula
  desc "Watch a file or folder and automatically commit changes to a git repo easily"
  homepage "https://github.com/gitwatch/gitwatch"
  url "https://github.com/gitwatch/gitwatch/archive/refs/tags/v0.2.tar.gz"
  sha256 "38fd762d2fa0e18312b50f056d9fd888c3038dc2882516687247b541b6649b25"
  license "GPL-3.0-or-later"
  head "https://github.com/gitwatch/gitwatch.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "3bc2b21cc3d0343938231c6e6d0db2cc3762e7abadc9b972a948527ce1b73ce9"
  end

  depends_on "coreutils"

  on_macos do
    depends_on "fswatch"
  end

  on_linux do
    depends_on "inotify-tools"
  end

  def install
    bin.install "gitwatch.sh" => "gitwatch"
  end

  test do
    repo = testpath/"repo"
    system "git", "config", "--global", "user.email", "gitwatch-ci-test@brew.sh"
    system "git", "config", "--global", "user.name", "gitwatch"
    system "git", "init", repo
    pid = spawn "gitwatch", "-m", "Update", repo, pgroup: true
    sleep 15
    touch repo/"file"
    sleep 15
    begin
      assert_match "Update", shell_output("git -C #{repo} log -1")
    ensure
      Process.kill "TERM", -pid
    end
  end
end
