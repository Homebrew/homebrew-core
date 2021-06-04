class Dcd < Formula
  desc "Auto-complete program for the D programming language"
  homepage "https://github.com/dlang-community/DCD"
  url "https://github.com/dlang-community/DCD.git",
      tag:      "v0.13.4",
      revision: "8dce131a8ec715382a104feed52d08a1aacdc960"
  license "GPL-3.0-or-later"
  head "https://github.com/dlang-community/dcd.git"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "3f78982cca3087697d53cf0e240dfcd8d601f9b25d80f01ad6ff237a1604ea16"
    sha256 cellar: :any_skip_relocation, catalina: "4a77f9bb6025a0ea9c30372dad8bb548226100f81391340a39cdde29e9a9ae13"
    sha256 cellar: :any_skip_relocation, mojave:   "a6ad4603f6ca68b68be9ca7716875f38a537c3dea00f15dcfa8b4f0edbe9dc07"
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
