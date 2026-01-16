class Kubetui < Formula
  desc "TUI tool for monitoring and exploration of Kubernetes resources"
  homepage "https://github.com/sarub0b0/kubetui"
  url "https://github.com/sarub0b0/kubetui/archive/refs/tags/v1.12.0.tar.gz"
  sha256 "d741a0ba3eed72916986747528dda2d4f2d8d91b9bcf920bf5113f057eb79090"
  license "MIT"
  head "https://github.com/sarub0b0/kubetui.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fe8988430e94491315426dc5e41eb001b9f837004c9f07965964efb8ea8246ae"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1d3c51cdb0f5759726750a07a82f7416f8bf2e51db4b5fc04d5681be36c50e2a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f79a2803dfe2d98bb891b1fd3b4f6ea45974f96a9d7f63381466e62662258e49"
    sha256 cellar: :any_skip_relocation, sonoma:        "ed9f74deb5409364c34cc9e7f4dd73b486e966baf6422a6abf9d44c5ffd7c2f6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b2ed91d3e29deeb396656f2abbd4c1bb2a3f6b65c1ec5994ddfa7086a919ac37"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "57bd46bd48cca5b4189f32bcf19599979156c237d6efbdc3faeddfd3c6e69427"
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
