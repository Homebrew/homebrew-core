class Diffnav < Formula
  desc "Git diff pager based on delta but with a file tree"
  homepage "https://github.com/dlvhdr/diffnav"
  url "https://github.com/dlvhdr/diffnav/archive/refs/tags/v0.3.1.tar.gz"
  sha256 "a38552e6cc71100a65fd6a72b1e210c50a0cb16e12d7c2a4693f41b81cd9d3c7"
  license "MIT"
  head "https://github.com/dlvhdr/diffnav.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "766b8a324775eb82135648ab03c7413b3aeb71d71b43d3c9ee05e8abbf66d6b7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "766b8a324775eb82135648ab03c7413b3aeb71d71b43d3c9ee05e8abbf66d6b7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "766b8a324775eb82135648ab03c7413b3aeb71d71b43d3c9ee05e8abbf66d6b7"
    sha256 cellar: :any_skip_relocation, sonoma:        "a6f1be8aef93a0ec85cd7cc2b9724004cc5497fbd115e61a29114b7b0a5ad064"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e236211305c388cf45c6d4b47ebb0da64bcc36de572cc1b2e553736e2998ed0e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9cc107b6a49e2a02038cd986376362205fac05a7597662e8dc270ac7ee34869f"
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
