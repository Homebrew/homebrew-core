class Diffnav < Formula
  desc "Git diff pager based on delta but with a file tree"
  homepage "https://github.com/dlvhdr/diffnav"
  url "https://github.com/dlvhdr/diffnav/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "501b5b283a23c9e58788c4dc1c384c27760dd20d82e801256e7ede86f39240af"
  license "MIT"
  head "https://github.com/dlvhdr/diffnav.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a68d66f4c28700eb420cf6eaeef98cc8e4b288cda954675be094dfeda231a70f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a68d66f4c28700eb420cf6eaeef98cc8e4b288cda954675be094dfeda231a70f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a68d66f4c28700eb420cf6eaeef98cc8e4b288cda954675be094dfeda231a70f"
    sha256 cellar: :any_skip_relocation, sonoma:        "359823b319ff065b1f45c18a8fcbd1c3795df8b2417298bfb5ea0278ff6ef393"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "16e4594d9c0b3d9f21a4414d667a2c881d2b43c0f254b090fd58ace865135089"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "be1e01f7760d343d02be06364bc4e3b0e3d08185bd6d0b15f2195f9cf758e53f"
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

    r, w, pid = PTY.spawn("git diff | #{bin}/diffnav")
    sleep 1
    w.write "q"
    assert_match "test.txt", r.read
  rescue Errno::EIO
    # GNU/Linux raises EIO when read is done on closed pty
  ensure
    Process.kill("TERM", pid) unless pid.nil?
  end
end
