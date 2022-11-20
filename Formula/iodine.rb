class Iodine < Formula
  desc "Tunnel IPv4 traffic through a DNS server"
  homepage "https://code.kryo.se/iodine"
  url "https://github.com/yarrick/iodine/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "7281e2301804e48029877bab27134f7c0eb04567da4d21a6fcbaa7265cb5849e"
  license "ISC"
  head "https://github.com/yarrick/iodine.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "160daa4315596721e991040e2933ec7f770abac2a337f4a61a6d8fd4a583c14c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a10e3aa93f18b0908ea3793fbf405497deb44e93a76508445590aa4a374a5254"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6fc4894da3e0117b7720297a2631554533327849eee8e1f5f5f24bdb78e1d420"
    sha256 cellar: :any_skip_relocation, ventura:        "09b258c8c0baa29db1756c7d9538a0376e1df2e9263e0e0ea1491a64e4de823b"
    sha256 cellar: :any_skip_relocation, monterey:       "72c1c550528ba132f8f5039176fb2af381fdc4e07eb3dd43d9e521856faa24a2"
    sha256 cellar: :any_skip_relocation, big_sur:        "9b851bf463d97330612aa1a91169b34684c1846a5295c0063df6a43aa6f9e933"
    sha256 cellar: :any_skip_relocation, catalina:       "783a1870f552684208e9eca58eac6461373fd7a489208afd6c31a5aee797fa1d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7b8061db0229e0a1c5abb04106ce7bb28001e81cda0cf6d42362133a90cd6b32"
  end

  depends_on "cmake" => :build

  uses_from_macos "zlib"

  def install
    system "make", "prefix=#{prefix}", "install"
  end

  test do
    # iodine and iodined require being run as root. Match on the non-root error text, which is printed to
    # stderr, as a successful test
    assert_match("iodine: Run as root and you'll be happy.", pipe_output("#{sbin}/iodine google.com 2>&1"))
    assert_match("iodined: Run as root and you'll be happy.", pipe_output("#{sbin}/iodined google.com 2>&1"))
  end
end
