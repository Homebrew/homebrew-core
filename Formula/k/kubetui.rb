class Kubetui < Formula
  desc "TUI tool for monitoring and exploration of Kubernetes resources"
  homepage "https://github.com/sarub0b0/kubetui"
  url "https://github.com/sarub0b0/kubetui/archive/refs/tags/v1.5.0.tar.gz"
  sha256 "137ef45cb539a56b16990c72ae60c7247d4ff90be3c16eec029dbd5e0480e677"
  license "MIT"
  head "https://github.com/sarub0b0/kubetui.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "eba5ee9bc56736420933c2f69307bb49639b1f319f7974f76075904be5efda5d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "13b772cc16af8f47c7716c4b1204a8f1ff68d4a93621e196164edab200870f63"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a522fa4beeb9c529df34fc3ed25b53f06bfc1062987d6c2927b7b1071e20c9bd"
    sha256 cellar: :any_skip_relocation, sonoma:         "65019544023fd5264c10972df3bc22fc6658d4dca9a1b069ce4e19aade744d33"
    sha256 cellar: :any_skip_relocation, ventura:        "daad1b92f1a52cfbbd756534ee91deae0594ebc0aaae697fc2d67972244176fa"
    sha256 cellar: :any_skip_relocation, monterey:       "01dc4cb4048d832721838a73521fb0751e852b5b5afdd9a4aa2dc1372683d297"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "83330e9ed6d5c2655c9f21f8bb5700d870992df63e2212d3e18bfe04f175ad12"
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
