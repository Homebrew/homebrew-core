class PodmanTui < Formula
  desc "Podman Terminal User Interface"
  homepage "https://github.com/containers/podman-tui"
  url "https://github.com/containers/podman-tui/archive/refs/tags/v0.18.0.tar.gz"
  sha256 "2616749995cb787e9dce2a773d531fe5e0bf833b18ab6242c65c873655300792"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b85a1d661ffeefe45e5e22988382e4413ba8f80f3dc00865f87c0016bfe4406a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "85a77c6adbb0fceecc190f89d489e20d6c74e106f4ff399baff28429312375e5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "710f3572aca7c5ec33052a3945aeec69d2ea0fd6eb475e6741817730b48bcbf8"
    sha256 cellar: :any_skip_relocation, sonoma:         "af7cfde1e1b0b5ed7abd6ae06d34b3f17844c3bab6d0e7c75e1fb002906307ed"
    sha256 cellar: :any_skip_relocation, ventura:        "b70b2a7980447064e027e39ffa73c358480ebc6102f2f32c336df38029ed5cc7"
    sha256 cellar: :any_skip_relocation, monterey:       "b9b5a73222fad4edcd75dae8738d7fc454061c81cd478c2f5a55577ac9e0c442"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "154f7075e2d11e47a6fe8be27b9bfcca17f2277208b995a78f8353aeabeb96fe"
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
