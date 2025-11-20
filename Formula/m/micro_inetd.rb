class MicroInetd < Formula
  desc "Simple network service spawner"
  homepage "https://web.archive.org/web/20241115023917/https://acme.com/software/micro_inetd/"
  url "https://pkg.freebsd.org/ports-distfiles/micro_inetd_14Aug2014.tar.gz"
  version "2014-08-14"
  sha256 "15f5558753bb50ed18e4a1445b3e8a185f3b1840ec8e017a5e6fc7690616ec52"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "420a213af59e22190bbe8acb13f7165b444246ecb3e9e5f3778a93b0a8c039a3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "9693aed7c6ab1caf581335fefd2eea3fcde0e3b62fbbe1378cd81bba864410a4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "232b03dbe326168f085f817aa5f54dfbd1d1793e6eced2991fcf5c27c932f3c4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2571772cdf0c887a13fa608f34a9bd4e866634f72c7df20a04aa6426e8e0f634"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "523ce480e35f50c093ebe4b0ae2c60b6a21007f0543a697b173c562c10a2639f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8c92f09e894e133f5f3a51c1df7c0a9a540daa8c2b5e028dd37a10afbfebdf40"
    sha256 cellar: :any_skip_relocation, sonoma:         "a43b8b8fc6ff27a158b7e2bedc62ed709c17c937b76644adfcdc4130902c2669"
    sha256 cellar: :any_skip_relocation, ventura:        "bae8f59efd2b2847b2b11456aef8219b50a3c60c9217b49219a6370d1bb69030"
    sha256 cellar: :any_skip_relocation, monterey:       "54355e595c1f260dae362dcea2dad1bd9a382fa37d787ccb9af801d34564f3a2"
    sha256 cellar: :any_skip_relocation, big_sur:        "61bb8fda68189596e32e2aa86e986b32779d61337498ca2145421b7dce09e40d"
    sha256 cellar: :any_skip_relocation, catalina:       "04b4028a1fab40575b422ea45b44317dc69170f85bf4fa07b4eb7d2f8df165ee"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "db73408b4adcb3c29579c532ad06896c258f1dbbf13057279df8b2a11e78cc3b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5c12f725a115ea5becccc0b125b34d285af5b5fc2be361cec10ba745ba8b238c"
  end

  # Original URLs are dead and last release from 2014-08-14
  deprecate! date: "2025-03-18", because: :unmaintained

  def install
    bin.mkpath
    man1.mkpath
    system "make", "install", "BINDIR=#{bin}", "MANDIR=#{man1}"
  end

  test do
    port = free_port
    pid = spawn bin/"micro_inetd", port.to_s, "/bin/echo", "OK"

    # wait for server to be running
    sleep 1

    TCPSocket.open("localhost", port) do |sock|
      assert_equal "OK", sock.gets.strip
    end
  ensure
    Process.kill "TERM", pid
    Process.wait pid
  end
end
