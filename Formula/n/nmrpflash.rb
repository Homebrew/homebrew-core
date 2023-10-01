class Nmrpflash < Formula
  desc "Netgear Unbrick Utility"
  homepage "https://github.com/jclehner/nmrpflash"
  url "https://github.com/jclehner/nmrpflash/archive/refs/tags/v0.9.21.tar.gz"
  sha256 "0be3a8771087b592002258ce6f34729da7a76d81eff52ac95dee788c0f4fc9b3"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bb409a3da185ab4f0eab3d2bced58968fa73337b8ece30620895a1bdcd005b03"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "986a226ee3498af37ff8508764671fc0b5120b3f406666c8fbdec2a8367bbdbe"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ac28182aff50b1b59ec74ae1a8d85f142da331a099479c84c0305a847323778a"
    sha256 cellar: :any_skip_relocation, ventura:        "2095ab26f5da3fd8ece982cd1c4a9876cf4bda03e9780b363f513043212d8706"
    sha256 cellar: :any_skip_relocation, monterey:       "2509a906059b82fd06583b0283ed3bd7b83b665ac0d9a343c407d0bf8d002d08"
    sha256 cellar: :any_skip_relocation, big_sur:        "abf54e145dac5c102de298a5c1a08f6a5d3388ba5197610e91ae4c4e1e1509fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7c0bf9c0f6f4b26b57d53e62e540be3a4f088c35b6030edddc5c1e890bf4f750"
  end

  uses_from_macos "libpcap"

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "libnl"
  end

  def install
    system "make", "install", "PREFIX=#{prefix}", "VERSION=#{version}"
  end

  test do
    system bin/"nmrpflash", "-L"
  end
end
