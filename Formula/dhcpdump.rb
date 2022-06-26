class Dhcpdump < Formula
  desc "Monitor DHCP traffic for debugging purposes"
  homepage "https://www.mavetju.org/unix/general.php"
  url "https://www.mavetju.org/download/dhcpdump-1.8.tar.gz"
  mirror "https://deb.debian.org/debian/pool/main/d/dhcpdump/dhcpdump_1.8.orig.tar.gz"
  sha256 "6d5eb9418162fb738bc56e4c1682ce7f7392dd96e568cc996e44c28de7f77190"

  livecheck do
    url :homepage
    regex(/href=.*?dhcpdump[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1a948ff9d54f73ace571fef91ff0ea06c09216ecac07e4665526ad4caeb680de"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ea331a3bb132f7f9fbc334e85fd7d7cfc6cf7314df93bf123c5e042febbe1951"
    sha256 cellar: :any_skip_relocation, monterey:       "305c41098112a0cd36fcbf838f9a9d575ae2764ffa7db65fa2f53874639b4cfa"
    sha256 cellar: :any_skip_relocation, big_sur:        "c6661ad77e8aa1a0355ca8c93454e9a5cba9936790b2fdbf97ada7c7e094af1a"
    sha256 cellar: :any_skip_relocation, catalina:       "508365f542d3fc6574525a2b2ccacc4467b40fd53b9885e8c4e91e9e2b172f21"
    sha256 cellar: :any_skip_relocation, mojave:         "5c0e4a3120148871209e5943dd42c5fc81ad6b8d0e78e0964d2dc46829ac5030"
    sha256 cellar: :any_skip_relocation, high_sierra:    "d49aaa82bf92fd7adeb0edb91812d4c48aa20fb0af2f30f9b4238d032dbb99ce"
    sha256 cellar: :any_skip_relocation, sierra:         "10e6565cdd5717666822ce9a0f77747d44969b5cbc7c3ccf1505aaa6ba95af85"
    sha256 cellar: :any_skip_relocation, el_capitan:     "1f30cb4146a741b3523d674336854c665546e939af04f619e38623d9298cd4ef"
    sha256 cellar: :any_skip_relocation, yosemite:       "6df64653cfd4b118db43e2acb2f08a565ac3cba9e1b739a258eeb7655c1a6103"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f1fe4468b6228999e79e24c13f4b4e65b32d8124f1928f08960b2b144ed63077"
  end

  uses_from_macos "libpcap"

  def install
    system "make", "CFLAGS=-DHAVE_STRSEP"
    bin.install "dhcpdump"
    man8.install "dhcpdump.8"
  end

  test do
    system "#{bin}/dhcpdump", "-h"
  end
end
