class Kubetui < Formula
  desc "TUI tool for monitoring and exploration of Kubernetes resources"
  homepage "https://github.com/sarub0b0/kubetui"
  url "https://github.com/sarub0b0/kubetui/archive/refs/tags/v1.7.0.tar.gz"
  sha256 "1aead11c607c9fcd359dccf2b52c96d223ee32909a06495d9091bd6f531aa407"
  license "MIT"
  head "https://github.com/sarub0b0/kubetui.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "caab723bd87835d56584343054751b248811bc58d2cc38c60f15734ae8fad9de"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "40b807b05e82b8ddc11aaf4b2c86ffeeb16100d413b0c11e18371b48fcff9cb6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f477d181b77060691f2373efdd1bca3a7fe09af0d5e55a51e90bb462fb73446e"
    sha256 cellar: :any_skip_relocation, sonoma:        "810ca3742faf25f03acbbf0c75dc0fc1051fa1a51029cb620eff8cff04b2783d"
    sha256 cellar: :any_skip_relocation, ventura:       "3524664a3c26ba0e069fe8eab5c662ee94b8e23d7f4ac2824938bb532d663428"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2c33490fa379e38bce16f708d4dde95ea77de2250d319e352dd736606070faa3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "64b0711c87e8e99e4e901a390ce2a2dbf78d51c52475f2417c4e6ae7db917435"
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
