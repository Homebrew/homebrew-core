class Gitwatch < Formula
  desc "Watch a file or folder and automatically commit changes to a git repo easily"
  homepage "https://github.com/gitwatch/gitwatch"
  url "https://github.com/gitwatch/gitwatch/archive/refs/tags/v0.4.tar.gz"
  sha256 "113fbb0ee7634ccb321534d607df191ce87066137e058b58c0a4dfec696b43ef"
  license "GPL-3.0-or-later"
  head "https://github.com/gitwatch/gitwatch.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "9af9425316b5d6fb3232bc120934eb03a9f6f93b6b07b613496cd9da2ef94d6b"
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
