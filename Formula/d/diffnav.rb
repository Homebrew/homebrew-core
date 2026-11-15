class Diffnav < Formula
  desc "Git diff pager based on delta but with a file tree"
  homepage "https://github.com/dlvhdr/diffnav"
  url "https://github.com/dlvhdr/diffnav/archive/refs/tags/v0.13.1.tar.gz"
  sha256 "0276d21f3a4a2aa90b84c89fa2e7f08f7cecef1ddcf624103594ce93f959de2b"
  license "MIT"
  head "https://github.com/dlvhdr/diffnav.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "9740daad89efefff55e3ef19b0275d88500dda80e54af6f5cb674adf5196918b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "9740daad89efefff55e3ef19b0275d88500dda80e54af6f5cb674adf5196918b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "9740daad89efefff55e3ef19b0275d88500dda80e54af6f5cb674adf5196918b"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "120a93dfdb444473de3de797112647400555dd75e969247ad4832da9372a7fab"
    sha256 cellar: :any,                 x86_64_linux:      "2a08dec7502bb422cb6cb99d5442683b4ff57a2d7d6871b4da98769c90336f55"
  end

  depends_on "go" => :build
  depends_on "git-delta"

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args
    generate_completions_from_executable(bin/"diffnav", shell_parameter_format: :cobra)
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
