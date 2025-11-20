class PodmanTui < Formula
  desc "Podman Terminal User Interface"
  homepage "https://github.com/containers/podman-tui"
  url "https://github.com/containers/podman-tui/archive/refs/tags/v1.9.0.tar.gz"
  sha256 "7a0e89d71a18527f01be061c8d449823770cff768b6d716cef96b979f3672de7"
  license "Apache-2.0"
  head "https://github.com/containers/podman-tui.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "159fe3cbe81cb90352a7cdd6e9fecda9ffbe0d4ed70b8238d23b28a3a577cad3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ae8d3b12b6d240b955412b516b7481d078f0df567ee1bf2505b6f5d7fa0fee2f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2ce978d60030735023a0ea7b7c60654264d8a78766ec62f04cebb5fce418be85"
    sha256 cellar: :any_skip_relocation, sonoma:        "0c3901ccd6a710f3a1ba420543192de39ef4ed1682e3259a6612b4cdc382f031"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fb3be056e3171386c8d9c3819f52b91e44c318d2af71e9689dd744a16f1fd134"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "04453e9ee308df6601ac642852498519989e8213cac4dcf1699fd9495d2e7c3f"
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
