class PodmanTui < Formula
  desc "Podman Terminal User Interface"
  homepage "https://github.com/containers/podman-tui"
  url "https://github.com/containers/podman-tui/archive/refs/tags/v1.8.1.tar.gz"
  sha256 "08434e9c70a19bc4ec35a57648b0ca718719c155feb3daa5458e6115cea377dc"
  license "Apache-2.0"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b5bab9e9e4ff477281949f1af0d0017fcb4fb8fa4556fbf7ae023d728af9bb0a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "278978f94f2d064793436e301c4c748ce89634b9e542b7eac17068c4195190a3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8451b9ff4d512b9a2f5b2c1ff7e6850f28dc188deb3f9aa475839ab9b7cc2391"
    sha256 cellar: :any_skip_relocation, sonoma:        "3178f3fed71ed4e0c0df76e4e9701c19a6b52350dfd0a9dd78e2142932dbb184"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "57558782ae07291ec662dcc7cea51b2549baf02433d32b7407b4ad4bed6cf445"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d3e0d1bce3874bd505c28b6e3a0211581b47dfe635cc098ef2864bb9a398dccd"
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
