class PodmanGvproxy < Formula
  desc "Network stack for Podman based on gVisor"
  homepage "https://github.com/containers/gvisor-tap-vsock"
  url "https://github.com/containers/gvisor-tap-vsock/archive/v0.1.0.tar.gz"
  sha256 "e1e1bec2fc42039da1ae68d382d4560a27c04bbe2aae535837294dd6773e88e0"
  license "Apache-2.0"

  depends_on "go" => :build

  def install
    system "make"
    bin.install "bin/gvproxy"
  end

  test do
    assert_match(/cannot listen: listen unix/i, shell_output("#{bin}/gvproxy 2>&1"))
  end
end
