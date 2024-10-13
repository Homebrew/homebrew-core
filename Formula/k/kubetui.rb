class Kubetui < Formula
  desc "TUI tool for monitoring and exploration of Kubernetes resources"
  homepage "https://github.com/sarub0b0/kubetui"
  url "https://github.com/sarub0b0/kubetui/archive/refs/tags/v1.5.3.tar.gz"
  sha256 "6cf993dd0960e3a7d62ddb62819827e0a5e97b4efb84e9df0f0637b65204e846"
  license "MIT"
  head "https://github.com/sarub0b0/kubetui.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "6658e9a007b2aed3894aa94ab80ceb7c16071578648e8f4f0c1870d17e2a245c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c9bb18b65662c2b1be75ef3f9386cce60f5ccfc9382f240583131988b917b8e7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f3746e023cb48704d5e11dcbd1975998ad17a0682d92915605838b64f94b174f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a8314b787782eec4f5168260f2f9ce69ca69cd4f570bc043a9c01e198a78100b"
    sha256 cellar: :any_skip_relocation, sonoma:         "af582c10687f2d4397c629feafa61b3624b4b38781738dde5ff54817ee47ee1a"
    sha256 cellar: :any_skip_relocation, ventura:        "1f8d55aaad0ef367362f66bd00770d26010632f3d52f43d30bda2041a7cff1f2"
    sha256 cellar: :any_skip_relocation, monterey:       "c67ca077c75f3df1d17f08ba936c77badd52864398919d4ca3861937cc9401cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ad41a4f507ccf98475638ce311984c68e34edff0b68505217f8524cd1323dc4c"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kubetui --version")

    # Use pty because it fails with this error in Linux CI:
    #   failed to enable raw mode: Os { code: 6, kind: Uncategorized, message: "No such device or address" }
    r, _w, pid = PTY.spawn("#{bin}/kubetui --kubeconfig not_exist")

    output = ""
    begin
      r.each_line { |line| output += line }
    rescue Errno::EIO
      # GNU/Linux raises EIO when read is done on closed pty
    ensure
      Process.wait(pid)
    end

    assert_match "failed to read kubeconfig", output
    assert_equal 1, $CHILD_STATUS.exitstatus
  end
end
