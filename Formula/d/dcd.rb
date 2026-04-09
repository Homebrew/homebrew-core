class Dcd < Formula
  desc "Auto-complete program for the D programming language"
  homepage "https://github.com/dlang-community/DCD"
  url "https://github.com/dlang-community/DCD.git",
      tag:      "v0.16.2",
      revision: "a0441ba8c5c7d841e481413a56a1ebe4f8364811"
  license "GPL-3.0-or-later"
  head "https://github.com/dlang-community/dcd.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1966e81506f5f625ed5b722e5c175627e6e0d43a92476cf5c9d0ccf913543342"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a4f17aaf983de82ecebb439d2930d0931f0fc14cdf26461eedf8957324a305a5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f14a2baca4b73884355567d5f7f79704228fbbec0b9d393ad57ef03258358873"
    sha256 cellar: :any_skip_relocation, sonoma:        "069055822ce1852715cc2f0706817a14c4d44850828518c8a89cfcd5dce89e86"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ee6cafd4c32a6e22bf4413553a3f0e146b793705d10e7a184607f01dc7361ac3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6b1a68af1ecbab4810fce908f67b3f569e28bc55cf4e851c07d456ca11a92d96"
  end

  depends_on "ldc" => :build

  def install
    system "make", "ldc"
    bin.install "bin/dcd-client", "bin/dcd-server"
  end

  test do
    port = free_port

    # spawn a server, using a non-default port to avoid
    # clashes with pre-existing dcd-server instances
    server = spawn bin/"dcd-server", "-p", port.to_s
    # Give it generous time to load
    sleep 0.5
    # query the server from a client
    system bin/"dcd-client", "-q", "-p", port.to_s
  ensure
    Process.kill "TERM", server
    Process.wait server
  end
end
