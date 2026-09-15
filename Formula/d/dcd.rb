class Dcd < Formula
  desc "Auto-complete program for the D programming language"
  homepage "https://github.com/dlang-community/DCD"
  url "https://github.com/dlang-community/DCD.git",
      tag:      "v0.19.2",
      revision: "ba289786efbea3bf409f83b53c7a92003a63924b"
  license "GPL-3.0-or-later"
  head "https://github.com/dlang-community/dcd.git", branch: "master"

  bottle do
    sha256               arm64_golden_gate: "60380790a6c91eec8e865f0456d9dfd918e9175820465507378621c37f4a3015"
    sha256               arm64_tahoe:       "4f94dafa56d7d52dac4e3d4f67f79794656d526fdeae7f98fc54111ff0d23122"
    sha256               arm64_sequoia:     "f677ea948a15632126b4ca41908782ff659fbe4a2d8dc3b0b95f850dc7756567"
    sha256 cellar: :any, arm64_linux:       "276b9949c6a91577678756d9d0cbea832055fbefa806dcbde468799d91adeb51"
    sha256 cellar: :any, x86_64_linux:      "f3439aab5ea2fd5e3c93926ed1d993a755ed59ffa14c19e31d1c8add0c7d384a"
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
