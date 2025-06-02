class Kubetui < Formula
  desc "TUI tool for monitoring and exploration of Kubernetes resources"
  homepage "https://github.com/sarub0b0/kubetui"
  url "https://github.com/sarub0b0/kubetui/archive/refs/tags/v1.7.1.tar.gz"
  sha256 "9789a466d85ff336d2485e772a3b47a0d1ff0b8869e6bf868005eb8daca611f4"
  license "MIT"
  head "https://github.com/sarub0b0/kubetui.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3c299dc728b56a5c5528f1b947cbf2a330a7cdef295c85c9d2849f42aab011f3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9bb4850601fc8e85a69e2274bd08399c3db48664fe4d4e5a4e75ae365602dced"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "12e4b37cb9d80f27ae380fabaa506e3cd45eaff1f5c131ddb0797e51561d2842"
    sha256 cellar: :any_skip_relocation, sonoma:        "1047745793b341dd3f759571538e2dc00664fe8c6057128edd2551da8ebc65ee"
    sha256 cellar: :any_skip_relocation, ventura:       "f94b9c90dd1d9ab5358f6a1090234b58340b7beaf58b6e9833da9ceb089178ab"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d806a43449d52f2a516e7d7fd778ad4615541ce6c26b30306df34e964ab602c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "490708ebb34caeb214dfff4efcb2d19be630e23cb25bd1cb427bb3b0c9b75431"
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
