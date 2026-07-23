class Kubetui < Formula
  desc "TUI tool for monitoring and exploration of Kubernetes resources"
  homepage "https://github.com/sarub0b0/kubetui"
  url "https://github.com/sarub0b0/kubetui/archive/refs/tags/v1.14.0.tar.gz"
  sha256 "6955061c22e7994f563176132602f03a7d07821e329fd751a18ca7f5e586d77b"
  license "MIT"
  head "https://github.com/sarub0b0/kubetui.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e058b9505808b58b02379c1bc0af6785237b2da96b7a748baaf5441a699f19e3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "64b39231cd69738e52a20e34835c8e57a40d48e0a97f86727729709bd57724f4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "780f49a0c37cc03768011441e5c339f3e0a2162135f0da5c8f8cc9b10b85339e"
    sha256 cellar: :any_skip_relocation, sonoma:        "50e6330592c4da0d403ee30216578c8620b616800ac2fb58ef845b62afc79a32"
    sha256 cellar: :any,                 arm64_linux:   "63decd6b21f71dd537f9bbb49f611fdd1f3cab1d35f58b3d7127e8fccdcafe63"
    sha256 cellar: :any,                 x86_64_linux:  "b6ec07469118fbf52ee22e48e12555bb35fbc71e2aa35e5b5e35337d905056cb"
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
