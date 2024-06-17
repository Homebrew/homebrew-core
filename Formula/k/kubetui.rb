class Kubetui < Formula
  desc "TUI tool for monitoring and exploration of Kubernetes resources"
  homepage "https://github.com/sarub0b0/kubetui"
  url "https://github.com/sarub0b0/kubetui/archive/refs/tags/v1.5.2.tar.gz"
  sha256 "8bcb9c7a64bc7b868b499399186a26f3476aa7606215dad29c48508801d436f5"
  license "MIT"
  head "https://github.com/sarub0b0/kubetui.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fa7f077b582a56c112c2db24a4cbc45de3e12e5bcacda2d4f7b9ba777455d7d9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3c783173e7ad1643e650836be1d2df8f3a126344838c2705d16f858adbabbb8d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5116d3f2294413f542ddaabddb2b0c4ee9457d3f292ee7b95d571bc14504cfbb"
    sha256 cellar: :any_skip_relocation, sonoma:         "3db976608d89e7502c0b0b556753c69b5a63aca84e733dfe6d60143c3a0424e7"
    sha256 cellar: :any_skip_relocation, ventura:        "798254fe85822f91941e3c427d6dcd03233ab2f7835f0707bd922d7a733e80fe"
    sha256 cellar: :any_skip_relocation, monterey:       "f202b7ee698e9d18e985a22c3a429eb53ad250ad6fd2703f49ba64d39b6bfea3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8fb3a038f6d1338802a4cb3f05b59030b07abf0535c462bd188611ec85427873"
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
