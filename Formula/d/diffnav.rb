class Diffnav < Formula
  desc "Git diff pager based on delta but with a file tree"
  homepage "https://github.com/dlvhdr/diffnav"
  url "https://github.com/dlvhdr/diffnav/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "2503e10c6c49f0926a33b78373ded5aea7c35b911ccf18d80df3c6d461e7d36f"
  license "MIT"
  head "https://github.com/dlvhdr/diffnav.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ecac4a1afe5e9eedab1b701f9326a7143bc4c0bffdce0a246f9a40ce814edf16"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ecac4a1afe5e9eedab1b701f9326a7143bc4c0bffdce0a246f9a40ce814edf16"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ecac4a1afe5e9eedab1b701f9326a7143bc4c0bffdce0a246f9a40ce814edf16"
    sha256 cellar: :any_skip_relocation, sonoma:        "2010b1588557b117ec36d91f058cb7443bcb9c2c8f1c81f55ece6e884ba26554"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "850cfc07701930dc801891504f4c1308adfbafd66780efc9113e9a2cae9a1901"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e883df9943c50d6b2ed91ca2e2f3a303bb68df4be4674b2b18e1387480531d76"
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
