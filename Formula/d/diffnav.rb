class Diffnav < Formula
  desc "Git diff pager based on delta but with a file tree"
  homepage "https://github.com/dlvhdr/diffnav"
  url "https://github.com/dlvhdr/diffnav/archive/refs/tags/v0.13.0.tar.gz"
  sha256 "c0915b7960db053479cbdd2dd9745e5822531ea17f3c8228da7a77842be92d97"
  license "MIT"
  head "https://github.com/dlvhdr/diffnav.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "fc09e546c8d4d6061d031764a773eec3a6b872cbe177b8f2c723e8f1831faa19"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "fc09e546c8d4d6061d031764a773eec3a6b872cbe177b8f2c723e8f1831faa19"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "fc09e546c8d4d6061d031764a773eec3a6b872cbe177b8f2c723e8f1831faa19"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "8e9d3d72bbdefa77364eeb3d4102574761669b8502ee47453eaac98c359f9238"
    sha256 cellar: :any,                 x86_64_linux:      "67abb1ed7ec45478aac2537471acb66473028090dcbe8a5cbe04f5f32587e63e"
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
