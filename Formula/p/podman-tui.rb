class PodmanTui < Formula
  desc "Podman Terminal User Interface"
  homepage "https://github.com/containers/podman-tui"
  url "https://github.com/containers/podman-tui/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "a89274fe1eb7c9dc90e52c2729e3cd6b4e0a892138fc95afc37e4ffd42fb40d6"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "737b0f8e8ceddf0e5795e66e05c7f6d913643ebef260cb94577d84654e200222"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7f128e9eae98ca10155da7b98f5f1a5ec95e1792966e8df930fbccb447dc3cb2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "95e3064c88154a1254d74321fbbbba63d2b6047b14c822318f03c43cf0c886ca"
    sha256 cellar: :any_skip_relocation, sonoma:         "5b1c73bfcbbb42edb3388bb9fe6321aa83d6e9b8bc3dbe9ef4ac8a7b07a892cb"
    sha256 cellar: :any_skip_relocation, ventura:        "cf8b19b35ccd968804003aaccdd1b18eb10be2a4283be5d9bd827d1981493995"
    sha256 cellar: :any_skip_relocation, monterey:       "12dd0575dcdec9f77cdc5e95fbaeb056e8798631463e212be1cab07d3d2d3196"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ef2c7c8620630263fa8a21fdfc0e189a705f1860f00dc1097ccf520c29e55c7c"
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
      sleep 1
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
