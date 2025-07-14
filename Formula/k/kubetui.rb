class Kubetui < Formula
  desc "TUI tool for monitoring and exploration of Kubernetes resources"
  homepage "https://github.com/sarub0b0/kubetui"
  url "https://github.com/sarub0b0/kubetui/archive/refs/tags/v1.9.0.tar.gz"
  sha256 "c2af4ff04c4bbf6ae7639c592b9b17a57990c124e5631e737dcbe75df3e06797"
  license "MIT"
  head "https://github.com/sarub0b0/kubetui.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4529cd3626e0a0c57ee0ecc969acb0f84677d2d7d159ab67b70e6dc1d1bf6a37"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0a09f0d9bd4daa1a3fd04f6ef567a79a5f4e8457b772402ef1e9a5f3879d1ff3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1f62aa14d051b842c42bcf3af28b27110aea08a632692dd4ed94356d58942064"
    sha256 cellar: :any_skip_relocation, sonoma:        "9143cc903a6854c87fe82d92c45d320e77502b97966010a690c6530ea49620c9"
    sha256 cellar: :any_skip_relocation, ventura:       "dfe764016c7fae24f99b735569a33eb5e797eacb9f9b48eff8d1c218b4afbe33"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ea3cb5fc4cd061635b508590e64cdc6e78053a5e2ea784d47bfde5767ef4fdec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0ab2b8cf074e0733fbe6431feaee6fb70d93110244d27b2ff0ff769f61be6470"
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
