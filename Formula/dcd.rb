class Dcd < Formula
  desc "Auto-complete program for the D programming language"
  homepage "https://github.com/dlang-community/DCD"
  url "https://github.com/dlang-community/DCD.git",
      tag:      "v0.13.6",
      revision: "02acaa534b9be65142aed7b202a6a8d5524abf2a"
  license "GPL-3.0-or-later"
  head "https://github.com/dlang-community/dcd.git"

  bottle do
    sha256 cellar: :any_skip_relocation, monterey:     "9e223a3fef8a39d75bbec9012bfa534d50772aa2d536857160c39221fe08f5bb"
    sha256 cellar: :any_skip_relocation, big_sur:      "e97405796485c96ea4dd9f7458cd548ed609f61ed8d5e006fb73ec00072d0811"
    sha256 cellar: :any_skip_relocation, catalina:     "1455dd1a3d4919d261c6cc8a73d05f62f4436f17b66d8790db249bcf4fbdcc6f"
    sha256 cellar: :any_skip_relocation, mojave:       "484f3c51a322172c8bab3cfa850685f91ce9dfdcccc85daeedead97cc63f13e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "58b613aa6a40fb855b592944f97bc7d66cbf87ee30e2243fd4e1551536b02d4f"
  end

  depends_on "dmd" => :build

  def install
    system "make"
    bin.install "bin/dcd-client", "bin/dcd-server"
  end

  test do
    port = free_port

    # spawn a server, using a non-default port to avoid
    # clashes with pre-existing dcd-server instances
    server = fork do
      exec "#{bin}/dcd-server", "-p", port.to_s
    end
    # Give it generous time to load
    sleep 0.5
    # query the server from a client
    system "#{bin}/dcd-client", "-q", "-p", port.to_s
  ensure
    Process.kill "TERM", server
    Process.wait server
  end
end
