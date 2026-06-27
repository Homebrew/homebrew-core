class Ipv6toolkit < Formula
  desc "Security assessment and troubleshooting tool for IPv6"
  homepage "https://www.si6networks.com/research/tools/ipv6toolkit/"
  url "https://github.com/fgont/ipv6toolkit/archive/refs/tags/v2.2.tar.gz"
  sha256 "b6a1af3d3cf417a81dbb4cd99cf710d16a62338be4bfbbb14b8d1cb298849338"
  license "GPL-3.0-or-later"
  head "https://github.com/fgont/ipv6toolkit.git", branch: "master"

  livecheck do
    url :stable
    regex(/^(?:ipv6toolkit[._-])?v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "523ecc5b67dede61b817503e7a3be3522e02c7d1faaedbe36d860ff921cc53e4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "454fa7a191d9a6fb060d38ffa9a3f35b00e48289762446e277092db3d7a20c6f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "87e6c3256fe91ee73c7712c58ebb884cb9a7109dd8ad6f42571ab4f3ca4671ad"
    sha256                               sonoma:        "f855b1e8d34e9dc55ca1ca1ba2762d256e79800798fcce7aa111bb4c41889281"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cfc7a43a31a1ee14958fa18004ef254e625680ee11e757b6af95ab2175cc4d5f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4a3b44ff9e1b83966463d601d04f9c3f458b52535bf84659469dbab9c44dfaef"
  end

  uses_from_macos "libpcap"

  def install
    system "make"
    system "make", "install", "DESTDIR=#{prefix}", "PREFIX=", "MANPREFIX=/share"
  end

  test do
    system bin/"addr6", "-a", "fc00::1"
  end
end
