class Meek < Formula
  desc "Blocking-resistant pluggable transport for Tor"
  homepage "https://www.torproject.org"
  url "https://gitweb.torproject.org/pluggable-transports/meek.git/snapshot/meek-0.38.0.tar.gz"
  sha256 "1bacf4bd2384aeb2ba8d4cdee7dbdfcbb71d6c366ad4e2840dffd9b159021e3a"
  license "CC0-1.0"
  head "https://git.torproject.org/pluggable-transports/meek.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "adb45229efe44b56e9badf0b4955b76e735c46e2a814afe9601579acfa3f0c44"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e87890b269d99509242918f0b49d0e974ec5d714cab804791420e2ba3a889961"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6b1bc91a0c81ce93bb3d274a8e44b1e16dfc9aa4377cd17f53e17a61cbb614a4"
    sha256 cellar: :any_skip_relocation, ventura:        "a04e4162bfabc0dca75f79e0b96485249060c7352618ec3e44d2af8219b33d8c"
    sha256 cellar: :any_skip_relocation, monterey:       "ea7c31b3bd02bab4d3951a0ea38a8e9a8c707c981a07929e3e540a05bcd97405"
    sha256 cellar: :any_skip_relocation, big_sur:        "cdeb7f4ecb736d27d60786ef384b12fdfb6c6ec3f91ffc6e94e72b892e93829a"
    sha256 cellar: :any_skip_relocation, catalina:       "e7b9e140649a3c62b86417a271ac39c5d080b0e065934ddc47b7c71eb158cb09"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5adc32589bfaf285e8cea09cd4730a21568aa2c76213cc7cbe15bbc96adf39e3"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(output: bin/"meek-client"), "./meek-client"
    system "go", "build", *std_go_args(output: bin/"meek-server"), "./meek-server"
    man1.install "doc/meek-client.1"
    man1.install "doc/meek-server.1"
  end

  test do
    assert_match "ENV-ERROR no TOR_PT_MANAGED_TRANSPORT_VER", shell_output("#{bin}/meek-client 2>/dev/null", 1)
    assert_match "ENV-ERROR no TOR_PT_MANAGED_TRANSPORT_VER", shell_output("#{bin}/meek-server 2>/dev/null", 1)
  end
end
