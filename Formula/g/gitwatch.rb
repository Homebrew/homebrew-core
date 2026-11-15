class Gitwatch < Formula
  desc "Watch a file or folder and automatically commit changes to a git repo easily"
  homepage "https://github.com/gitwatch/gitwatch"
  url "https://github.com/gitwatch/gitwatch/archive/refs/tags/v0.6.tar.gz"
  sha256 "0c49fb357377479710578d82b51a71a9d306bab00adf9c6ab9dae18ee7541489"
  license "GPL-3.0-or-later"
  head "https://github.com/gitwatch/gitwatch.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "b1cc4cb70d2d7d3aa194622c2383f66f52ab560be6d7ed981384714f1b415b5f"
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
    ENV["GIT_CONFIG_GLOBAL"] = "#{testpath}/.gitconfig"

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
