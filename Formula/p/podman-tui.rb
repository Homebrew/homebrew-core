class PodmanTui < Formula
  desc "Podman Terminal User Interface"
  homepage "https://github.com/containers/podman-tui"
  url "https://github.com/containers/podman-tui/archive/refs/tags/v1.2.3.tar.gz"
  sha256 "d513362b270672c688407673326a8b9d850f4351e07cd3841ca321a84d9f5622"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "14360354324f7baef0247cfbbbfbde040e8859d6853c5e0d79bea260a07fd2d0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2dc293c28f7da0625c7579afdf82801ffa7498d4d92e20643f84652c25f0d707"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9d14030cdf0fe5229f9e714742a020154b0d207755c4ba93cce5a8a386792568"
    sha256 cellar: :any_skip_relocation, sonoma:        "e49815e9898dbb711747aa49fac73932d5e996687b5ed9e23e8a978b5084e02c"
    sha256 cellar: :any_skip_relocation, ventura:       "55d6ababff783c021347964c877cb95734dbbceb4312904d65c419e348b6898c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "923190a7da8f97f94a8fd065d3cae1c513b2a423d3b97cbeef56dc53c54e217c"
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
