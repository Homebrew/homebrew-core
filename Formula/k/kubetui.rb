class Kubetui < Formula
  desc "TUI tool for monitoring and exploration of Kubernetes resources"
  homepage "https://github.com/sarub0b0/kubetui"
  url "https://github.com/sarub0b0/kubetui/archive/refs/tags/v1.6.0.tar.gz"
  sha256 "0de0a1a0ade1afdc6461c1ef808d0c81bbe450c543b918fe3dec176dc0221ad7"
  license "MIT"
  head "https://github.com/sarub0b0/kubetui.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5c6bc363d2ae61651db15c72facc2d81c17335294e76979401a41f605da4290d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7197d8fffc8149da26f6395c72e7d9df2ffc64b0a83ba9fc5a4dab6aad7e024f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d6a74b89c3bc86cf838f06f9f744a9ccc5327a0706e3a939b0e8a6a890b2cc57"
    sha256 cellar: :any_skip_relocation, sonoma:        "e89f054baf4b9d81e211035308fec393045cf89f4510f3b2f23ee671ddb946c8"
    sha256 cellar: :any_skip_relocation, ventura:       "b1e15ff66f42d8d094695c0b48b385330c5c6ba9ec3e1e6a78d924817f6ed73c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "065d2e0d7aaff02f37db17250ffee1a88c68a51043b19b5b5b9a1a038cc565bf"
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
