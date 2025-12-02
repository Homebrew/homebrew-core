class Kubetui < Formula
  desc "TUI tool for monitoring and exploration of Kubernetes resources"
  homepage "https://github.com/sarub0b0/kubetui"
  url "https://github.com/sarub0b0/kubetui/archive/refs/tags/v1.10.2.tar.gz"
  sha256 "2e5292defe794f259f0427dc98828b7f267c743297fe4b586ae7a084933a97a5"
  license "MIT"
  head "https://github.com/sarub0b0/kubetui.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0311aeb76be8c550987db3bed19718289ed0f8d9ce4f6881dcd376be9e7d4b86"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "190448ecfcb81f58414ca70a61d10f88a351970fc794fc2dc7d88eb0fe76e8dd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1ca0861f2e3ee593250aa86edadda567091a5b54cdcbf56c75e01fcab3adec6b"
    sha256 cellar: :any_skip_relocation, sonoma:        "a4a8cb3b14aabf8590fb7a3e25593e3f96240a4be3afb9a9d1fa73242fd25148"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "91ed8b57388bf34fa2b7c4b03fdbbfe2a4bb116f0c05cef5801897a2aa8a5a5b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "296efb579a373c6787264952004aff044baff8e25a95072d1556c12009eb9a5c"
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
