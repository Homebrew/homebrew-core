class Dcd < Formula
  desc "Auto-complete program for the D programming language"
  homepage "https://github.com/dlang-community/DCD"
  url "https://github.com/dlang-community/DCD.git",
      tag:      "v0.13.2",
      revision: "f38d36ab411748b1ee306fe5de607cf1e7058908"
  license "GPL-3.0-or-later"
  head "https://github.com/dlang-community/dcd.git", shallow: false

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "5a0727f629dcd28245385a8908af917b24887f2b1ecac6d767c1367050a0eba7"
    sha256 cellar: :any_skip_relocation, catalina: "bd5879df9d7b257213b9b73ce639fde37c81371b370ac904d3c48a3e4b1ee339"
    sha256 cellar: :any_skip_relocation, mojave:   "981f71ecf178c0a81d62491ac82595407722700ab080661ff074a53cbecb4f9d"
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
