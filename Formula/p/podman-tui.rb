class PodmanTui < Formula
  desc "Podman Terminal User Interface"
  homepage "https://github.com/containers/podman-tui"
  url "https://github.com/containers/podman-tui/archive/refs/tags/v1.3.1.tar.gz"
  sha256 "80cc3775361bc210cca825d2bf584ab5d5a2e9baece6c989792119c4ebd34733"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "047d3519c0744c7309f8be92a45f134dd19bb548be7c8ea223d4e875207c6a3d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f9d6c8f44244a87f0e3d55653f61f6077f5fab3358613d80868ec90549872374"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "36c1f31595a722dfbf56263872f855023d4ff6fc7e3cb22747631f92185334c2"
    sha256 cellar: :any_skip_relocation, sonoma:        "d673edd32d3080e906c59521d4afa9cd9feef3b7e9f021ecbbdd4fab9a3d3ffd"
    sha256 cellar: :any_skip_relocation, ventura:       "5b5ca71e52638e0c6c4e1207b4027bbf3c7282e27ff57493c3c3bf74416c6a42"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9182f9adeca51789788257b173d18657b1601fda67c07d86594e693172c74cc2"
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
