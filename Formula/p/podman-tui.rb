class PodmanTui < Formula
  desc "Podman Terminal User Interface"
  homepage "https://github.com/containers/podman-tui"
  url "https://github.com/containers/podman-tui/archive/refs/tags/v1.10.0.tar.gz"
  sha256 "18213b021dd3d33ef5f51f83220a342a13d1287fa4b00eef35aa9e5a1de00e2b"
  license "Apache-2.0"
  head "https://github.com/containers/podman-tui.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f218ff4bbdb0c77eb22065a91b58b4e59946127ea07c5058523ac4ac0da1ac62"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f218ff4bbdb0c77eb22065a91b58b4e59946127ea07c5058523ac4ac0da1ac62"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f218ff4bbdb0c77eb22065a91b58b4e59946127ea07c5058523ac4ac0da1ac62"
    sha256 cellar: :any_skip_relocation, sonoma:        "9d6860b0fc32d058effc6bb0b4c2ba72dbfc426de00e35a06d2c0b018a54f4d6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a6386fd9b908a05dba101126a17b574838bb21596e831e25a714115c8ef0b810"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b7a9c505b045074bc7215181bc4d6c5bc5eec600a126888023ca7fee98a19b05"
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
