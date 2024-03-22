class PodmanTui < Formula
  desc "Podman Terminal User Interface"
  homepage "https://github.com/containers/podman-tui"
  url "https://github.com/containers/podman-tui/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "d67d883381de8d105a2cddd38d5d61f0420a770f533844c59192640d6b5dafed"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5714067156d3eb4a1ac3060486c90d9b67f31417d857cb141307fbaa6c045600"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "459d6d09f7237995ec9fb3968b4b3d90a67fa841ca4ffac8d8ac59b2f4994550"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b7483f65ac12a43ad33deb23a5fefc9dbe12c8e7b568b7712ddc82b4d54c2a8c"
    sha256 cellar: :any_skip_relocation, sonoma:         "58643414148e1e298db0bf83a84c0871b014766574f74ef83c9aeea9ed7c5c89"
    sha256 cellar: :any_skip_relocation, ventura:        "dab4633ddf82a178c02c5ff8ed5ee0b21117d1455acb20dd4bbaf6584bd8730a"
    sha256 cellar: :any_skip_relocation, monterey:       "aa469c5d4e6b5cca2dd9ed11cd4990e2af10d0592fe256c18bcbb04744b5b883"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0ca1a0f1356a1cb3404d4361729ff12c92440e435b61e144b15b7383dfc76143"
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
