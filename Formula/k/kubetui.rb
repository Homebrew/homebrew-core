class Kubetui < Formula
  desc "TUI tool for monitoring and exploration of Kubernetes resources"
  homepage "https://github.com/sarub0b0/kubetui"
  url "https://github.com/sarub0b0/kubetui/archive/refs/tags/v1.13.0.tar.gz"
  sha256 "5f5fe16d2772de0567ce4174cd1c87a560e34c9ac268544ac68e21131750c1fa"
  license "MIT"
  head "https://github.com/sarub0b0/kubetui.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a8dcf32d520c8221e42906abb785f72a6e7e044c0a74ae74d039182c90aa8e35"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "44f7a5faa0ca542fae400e2a8040c4ef4387540e60a3003a67a8e389045fdc08"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "beb28247962fd9bf37b25fd3ddf8ebc13ceb507eac3de572809206323342dc54"
    sha256 cellar: :any_skip_relocation, sonoma:        "c09fdd6c17eca249349260ccb87a286fbaa4db3ce406d84e2fe7742cac32dde3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "19568034b887ec118afd21db8f9d0ee7fb88c4752836549e5a69da822bc3b606"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "03e8e0e7914b35d3c49b3e9a32f96a5c92bf3ffca5a05f155d12f4cbf8b941a2"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"kubetui", "completion", shells: [:bash, :zsh])
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
