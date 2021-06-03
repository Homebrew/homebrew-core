class Dcd < Formula
  desc "Auto-complete program for the D programming language"
  homepage "https://github.com/dlang-community/DCD"
  url "https://github.com/dlang-community/DCD.git",
      tag:      "v0.13.4",
      revision: "8dce131a8ec715382a104feed52d08a1aacdc960"
  license "GPL-3.0-or-later"
  head "https://github.com/dlang-community/dcd.git"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "20696fce98533b2c22ba295ef173610957ab942dc60e6afa4041ca0f62b89f98"
    sha256 cellar: :any_skip_relocation, catalina: "ac2ad349f223a80f91b37565b4ada4ced8dd27f4dab2bd9a3dfc8461ad359dee"
    sha256 cellar: :any_skip_relocation, mojave:   "01ed6652319b7aa33b4a34201be816489bab1f3ebca7581727db4921514f6bef"
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
