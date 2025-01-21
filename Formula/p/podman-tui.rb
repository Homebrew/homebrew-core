class PodmanTui < Formula
  desc "Podman Terminal User Interface"
  homepage "https://github.com/containers/podman-tui"
  url "https://github.com/containers/podman-tui/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "5a56d0f98e9537cefec1db2e685afc4f0453fcf0272a5f922f3ca04b3b2f9f59"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9310c741b728a529e41b386f90e9545879ec2a9d9743836ae8c3386b7ca00912"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "69d642f22d258188146815da437c44b83f3365bf9d42bc40df937008bdf8053e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8fc09659eeb270c4b02be6fa73ba539b08c45a033f931cd5b7be6b566a1699ae"
    sha256 cellar: :any_skip_relocation, sonoma:        "5a1004a18f259e9aa4c87b871f7341f4c3ceeee6b9fabb7bdaadeecb25668956"
    sha256 cellar: :any_skip_relocation, ventura:       "44493f98e364a1a9bfb67c2ecb0b66ffb859d1eb64f7ed73947bcfb70ec0b23f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "61533ab7ddec2e809064ec125e831804c90fd8e511a7d201a591110fbb57402c"
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
