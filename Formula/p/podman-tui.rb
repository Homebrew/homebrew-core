class PodmanTui < Formula
  desc "Podman Terminal User Interface"
  homepage "https://github.com/containers/podman-tui"
  url "https://github.com/containers/podman-tui/archive/refs/tags/v1.11.3.tar.gz"
  sha256 "55c7dd30cf106995361bfeb55d1f74f20d8a603a7cbbd3a03a4a8cdcc35aa6da"
  license "Apache-2.0"
  head "https://github.com/containers/podman-tui.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "71a315cbe2370fa6a7f530f5e82fca4504df13d9500240ece812bf77f7016eb9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "71a315cbe2370fa6a7f530f5e82fca4504df13d9500240ece812bf77f7016eb9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "71a315cbe2370fa6a7f530f5e82fca4504df13d9500240ece812bf77f7016eb9"
    sha256 cellar: :any_skip_relocation, sonoma:        "320dca5f43ac58f4098bc7422106ebd4268632b152b4166b76ea8edb6e1882ca"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0349b589752e653d22d4747f2f3587eeac5c470682bcc8a8ac852634187895c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bf5a9d76b8fc98a6985d3c8314741ce3135f7da1ca6fb5bae40f4f2c163f41bf"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    tags = "exclude_graphdriver_btrfs containers_image_openpgp remote"
    system "go", "build", *std_go_args(ldflags: "-s -w", tags:)
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
