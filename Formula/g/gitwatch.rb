class Gitwatch < Formula
  desc "Watch a file or folder and automatically commit changes to a git repo easily"
  homepage "https://github.com/gitwatch/gitwatch"
  url "https://github.com/gitwatch/gitwatch/archive/refs/tags/v0.3.tar.gz"
  sha256 "43a1efd96b57b11e8924850d338d17fc0f5fc52c19470eb3b515c2f07253cb73"
  license "GPL-3.0-or-later"
  head "https://github.com/gitwatch/gitwatch.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "821b4ce8427cf9b42eefdd04e17cfd7b28a6212c14b3f00ad6d5da33dcc2adf1"
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
