class Diffnav < Formula
  desc "Git diff pager based on delta but with a file tree"
  homepage "https://github.com/dlvhdr/diffnav"
  url "https://github.com/dlvhdr/diffnav/archive/refs/tags/v0.12.0.tar.gz"
  sha256 "17d9d1c1c2f5f8d223afaa9a73ce1ce5faa41fe5fb8a7bfd6d65e402d536d8d6"
  license "MIT"
  head "https://github.com/dlvhdr/diffnav.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "58bbfaff75476c6d3120db5779af70725ce16cbc3f6e85af7badf4453c3f9918"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "58bbfaff75476c6d3120db5779af70725ce16cbc3f6e85af7badf4453c3f9918"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "58bbfaff75476c6d3120db5779af70725ce16cbc3f6e85af7badf4453c3f9918"
    sha256 cellar: :any_skip_relocation, sonoma:        "dff717f85ffb16062b12f930aaf0aedcd3ce03751046fe7912df4d5f5f8291bb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e5c4938d58853070c9ba2ab2f56de6830837e744db8e9eea0f32abee8b872bc6"
    sha256 cellar: :any,                 x86_64_linux:  "be2694976e33fa9159994e003bea1eaaf594030d08f667d107efe3be808ef5cb"
  end

  depends_on "go" => :build
  depends_on "git-delta"

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
