class PodmanTui < Formula
  desc "Podman Terminal User Interface"
  homepage "https://github.com/containers/podman-tui"
  url "https://github.com/containers/podman-tui/archive/refs/tags/v2.0.0.tar.gz"
  sha256 "32c8ffced718cda2d5b4bcedddb71299aaa035f035de6886100ab0f6469ca3dd"
  license "Apache-2.0"
  head "https://github.com/containers/podman-tui.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d81002f5595efd25aab4539662c23117eeb9ce6cc6c34fd798184e03b8180220"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d81002f5595efd25aab4539662c23117eeb9ce6cc6c34fd798184e03b8180220"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d81002f5595efd25aab4539662c23117eeb9ce6cc6c34fd798184e03b8180220"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "d81002f5595efd25aab4539662c23117eeb9ce6cc6c34fd798184e03b8180220"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "3fe4c655b8778e59db48e6b090ed9d5665ebf3746073ce7eec70a66b4f40be08"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "bb09f18685d4f87349f9f04b9a989d70c993bc5c4314514a74f33ec75784594f"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ENV["CGO_ENABLED"] = "0"
    tags = "exclude_graphdriver_btrfs containers_image_openpgp remote"
    system "go", "build", *std_go_args(tags:)
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
        assert_match "SYSTEM CONNECTIONS[0]", output
      rescue Errno::EIO
        # GNU/Linux raises EIO when read is done on closed pty
      end
    end

    assert_match "podman-tui v#{version}", shell_output("#{bin}/podman-tui version")
  end
end
