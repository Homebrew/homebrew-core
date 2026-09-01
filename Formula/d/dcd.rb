class Dcd < Formula
  desc "Auto-complete program for the D programming language"
  homepage "https://github.com/dlang-community/DCD"
  url "https://github.com/dlang-community/DCD.git",
      tag:      "v0.16.5",
      revision: "4f15431dd97048bbdacfe94d6d2010219a350c88"
  license "GPL-3.0-or-later"
  head "https://github.com/dlang-community/dcd.git", branch: "master"

  bottle do
    sha256               arm64_tahoe:   "f2a8f8d93b78fe6b6270c16e5d65e5ee04d45fad0d329541f828aa463724afff"
    sha256               arm64_sequoia: "1e3e7952ca1abf57be9d556824c7cf4529e6a797c96403873749c7630dd9defe"
    sha256               arm64_sonoma:  "8db3c832c8d649ee69aac24b07b5ff49957dfaeaac95924eb93159d6eb7afac0"
    sha256 cellar: :any, arm64_linux:   "1b65b3161d176a33f48b4f24063b7c5e88704ad13438c1e55562ddff347fb6ff"
    sha256 cellar: :any, x86_64_linux:  "6b49c8c4029629ff051fa12470f44a217293698f147643426b8bb08055464b65"
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
