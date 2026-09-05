class Dcd < Formula
  desc "Auto-complete program for the D programming language"
  homepage "https://github.com/dlang-community/DCD"
  url "https://github.com/dlang-community/DCD.git",
      tag:      "v0.17.8",
      revision: "a3dbfa882f262cca3a8e3ab7abfc83258108f873"
  license "GPL-3.0-or-later"
  head "https://github.com/dlang-community/dcd.git", branch: "master"

  bottle do
    sha256               arm64_tahoe:   "f97869a00153f5a1410955f91696967bc547aeb932ae5405959075dec2986cd7"
    sha256               arm64_sequoia: "00d982766c1056629703b34ef1b3a9b6a53b36e41a2dc2c836de4aa38cb9a0bb"
    sha256               arm64_sonoma:  "7b4061fb1689648369d618568db54b3f95a1cd7f4c3a2f15736c83179b004bf0"
    sha256 cellar: :any, arm64_linux:   "5f8c567ea2c64f5ee838228ab1f2c88920edb0a4597f069de724d9cd2234dc1b"
    sha256 cellar: :any, x86_64_linux:  "9fc97f23029138870c092288fd82e94c438313c848931d0815987c0791b919d6"
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
