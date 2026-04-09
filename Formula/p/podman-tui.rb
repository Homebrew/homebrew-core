class PodmanTui < Formula
  desc "Podman Terminal User Interface"
  homepage "https://github.com/containers/podman-tui"
  url "https://github.com/containers/podman-tui/archive/refs/tags/v1.11.1.tar.gz"
  sha256 "210b691917864c0413134efeaa426139c9feefb3d039462a541ebddc6cae74e1"
  license "Apache-2.0"
  head "https://github.com/containers/podman-tui.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ae23d88bb8be1e0619ea9218f8725e498b22ea468bb6afcc3940f6bffb27a1bb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ae23d88bb8be1e0619ea9218f8725e498b22ea468bb6afcc3940f6bffb27a1bb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ae23d88bb8be1e0619ea9218f8725e498b22ea468bb6afcc3940f6bffb27a1bb"
    sha256 cellar: :any_skip_relocation, sonoma:        "9c57dd0df75f6fa206c2a102e1bb9ef5f59c050823494facf2e934440a319f53"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "28f0486866efd54d641f1d4a1021b2ccd5d53625fa7be3d33c0ece1337115649"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c5c535af8cac0eaefa23187db7bc4c7e60b97e9efdc0021943357f4a9d46fbf3"
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
