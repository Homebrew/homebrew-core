class PodmanTui < Formula
  desc "Podman Terminal User Interface"
  homepage "https://github.com/containers/podman-tui"
  url "https://github.com/containers/podman-tui/archive/refs/tags/v1.5.0.tar.gz"
  sha256 "d9ba16d37f959d7ae5ca6650c3ccc7b0e1a726215791c99604f8f5955ee8f61d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f6373d0a136f4711366640206e349fe97c42901a443405d8da56132878ebd7b4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "447fa401d2369f4db5988c3910c9066ffc6a82787a24c1f9ee6a4f51c59b13fd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e5797f063a42c71149249dfa692825479024b0cdc1d2258590866a505a3d428b"
    sha256 cellar: :any_skip_relocation, sonoma:        "bd7caa45fbbf484b796118e46f372ac401edbed58099cdb78b89017659d5d804"
    sha256 cellar: :any_skip_relocation, ventura:       "20181373cdee7592badce91436a5c476ba041c5c8e1532ed3f51d965c392cd21"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "680ba3c02fc1085a06b1f60d28e494b963fe7b50407da7005f25f7569b9cc699"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "430de3be21283d8c8b4b5ac63f04271cb497dbbe09c4bebfdb37b52f8b46d3f5"
  end

  depends_on "go" => :build

  def install
    if OS.mac?
      system "make", "binary-darwin"
      bin.install "bin/darwin/podman-tui" => "podman-tui"
    else
      system "make", "binary"
      bin.install "bin/podman-tui" => "podman-tui"
    end
  end

  test do
    require "pty"
    ENV["TERM"] = "xterm"

    PTY.spawn(bin/"podman-tui") do |r, w, _pid|
      sleep 4
      w.write "\cC"
      begin
        output = r.read
        assert_match "Connection:", output
        assert_match "SYSTEM CONNECTIONS[1]", output
      rescue Errno::EIO
        # GNU/Linux raises EIO when read is done on closed pty
      end
    end

    assert_match "podman-tui v#{version}", shell_output("#{bin}/podman-tui version")
  end
end
