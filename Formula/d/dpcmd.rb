class Dpcmd < Formula
  desc "Linux software for DediProg SF100/SF600"
  homepage "https://github.com/DediProgSW/SF100Linux"
  url "https://github.com/DediProgSW/SF100Linux/archive/refs/tags/V1.14.20.x.tar.gz"
  sha256 "d3e710c2a4361b7a82e1fee6189e88a6a6ea149738c9cb95409f0a683e90366e"
  license "GPL-2.0-only"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "bb586c3508f4200d44ab3140682b2fe9e1e0e9856a88c22fe064026e2ee3c696"
    sha256 cellar: :any,                 arm64_sonoma:   "75beaf85ba617a3d9a72ac7d2a5d6408b08bd511eadadc966321eff923b20efb"
    sha256 cellar: :any,                 arm64_ventura:  "4ae065587a1a8343e1716b7cfd8c1e397ada6c2851b6f59caab3a30a2cf5e18a"
    sha256 cellar: :any,                 arm64_monterey: "8706a95254b2a2edc441bb83f9d3d442e4b0ca2f48591a0f0dec9759e7d6c708"
    sha256 cellar: :any,                 sonoma:         "3dc78bd34e15e41ab7e0cc1d65993142180ab2e614df13ca090ad204c8c5cc20"
    sha256 cellar: :any,                 ventura:        "a052e8955437ff2157b47fdaac6841ae824e108b9744670c72beeedd3384a291"
    sha256 cellar: :any,                 monterey:       "ae6d857629a57212034b4e5f816ee40a3b0e52cba43de6c115a0bbb7fbe48b2c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "27ded0f06fabe16f572024c506404caf4e3fa55ac921ba42502f1f28e94ccbc5"
  end

  depends_on "pkg-config" => :build
  depends_on "libusb"

  def install
    system "make"
    bin.install "dpcmd"
  end

  test do
    # Try and read from a device that isn't connected
    assert_match version.to_s, shell_output("#{bin}/dpcmd -rSTDOUT -a0x100 -l0x23", 1)
  end
end
