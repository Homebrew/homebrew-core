class Diffnav < Formula
  desc "Git diff pager based on delta but with a file tree"
  homepage "https://github.com/dlvhdr/diffnav"
  url "https://github.com/dlvhdr/diffnav/archive/refs/tags/v0.11.0.tar.gz"
  sha256 "df3879b12275bed16065ad9c08107c874445d265aa1fdc51d5f66a1f2fb7f392"
  license "MIT"
  head "https://github.com/dlvhdr/diffnav.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2fab53e6a649edf1434ee108d81cf4d8810713ef5fd14c7cbe6b05059f22c850"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2fab53e6a649edf1434ee108d81cf4d8810713ef5fd14c7cbe6b05059f22c850"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2fab53e6a649edf1434ee108d81cf4d8810713ef5fd14c7cbe6b05059f22c850"
    sha256 cellar: :any_skip_relocation, sonoma:        "4d11a088fb274bda33190e0acdc786157ae32d4b303ddb42a1442a903df1e4dd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3e777d7c97922dda39af604506d950694fa8c3bf4fb2d6110210bc49eda676ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "42d4a4b37e195334e09191b9186ed35d26e9b152ec46850594f66cd494d6b545"
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
