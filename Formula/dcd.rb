class Dcd < Formula
  desc "Auto-complete program for the D programming language"
  homepage "https://github.com/dlang-community/DCD"
  url "https://github.com/dlang-community/DCD.git",
      tag:      "v0.13.1",
      revision: "92db0486968f8ee59c16099c21b133dc4e9d91cb"
  license "GPL-3.0"
  head "https://github.com/dlang-community/dcd.git", shallow: false

  bottle do
    cellar :any_skip_relocation
    sha256 "0bc934ba115fe511af6c7d8f5cdfc1856ddbb7c65951d16b3ac6ba3dbef2c535" => :catalina
    sha256 "0347c9bb620ae6cf490a5cc449cfd4cd7f3fe6842835a4b5b1b45acb84385a62" => :mojave
    sha256 "a7ab66d97edfb4118c7764101020029f2ece6f245d363dcc9b4cd1e1da2125bc" => :high_sierra
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
