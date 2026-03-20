class Diffnav < Formula
  desc "Git diff pager based on delta but with a file tree"
  homepage "https://github.com/dlvhdr/diffnav"
  url "https://github.com/dlvhdr/diffnav/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "29f988889d921bcd92509171885669dc253b4727f13d461f272fe1450a86ef2f"
  license "MIT"
  head "https://github.com/dlvhdr/diffnav.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "85a032f50014ba0f72476a7ccef89658a25d9eadda5505fb2c5003a4608b3c2f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "85a032f50014ba0f72476a7ccef89658a25d9eadda5505fb2c5003a4608b3c2f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "85a032f50014ba0f72476a7ccef89658a25d9eadda5505fb2c5003a4608b3c2f"
    sha256 cellar: :any_skip_relocation, sonoma:        "87168ecedd81acf1d48f881bddba4de4d47bca912aa66801b47c4ad5a383b60e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "375724998a7289c111b9a3a881aa87a087e8574858b3c08d093261bdbb00a7f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b788c32808d36e472591f72725c18c972c1e97821410b7d16a9ca96ba8387908"
  end

  depends_on "go" => :build
  depends_on "git-delta"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match(/No (diff|input provided), exiting/, shell_output("#{bin}/diffnav 2>&1"))

    system "git", "init", "--initial-branch=main"
    (testpath/"test.txt").write("Hello, Homebrew!")
    system "git", "add", "test.txt"
    system "git", "commit", "-m", "Initial commit"
    (testpath/"test.txt").append_lines("Hello, diffnav!")

    require "pty"
    begin
      r, w, pid = PTY.spawn("git diff | #{bin}/diffnav")
      r.winsize = [80, 43]
      sleep 1
      w.write "q"
      assert_match "test.txt", r.read
    rescue Errno::EIO
      # GNU/Linux raises EIO when read is done on closed pty
    ensure
      Process.kill("TERM", pid) unless pid.nil?
    end
  end
end
