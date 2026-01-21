class OpenOcd < Formula
  desc "On-chip debugging, in-system programming and boundary-scan testing"
  homepage "https://openocd.org/"
  url "https://downloads.sourceforge.net/project/openocd/openocd/0.12.0/openocd-0.12.0.tar.bz2"
  sha256 "af254788be98861f2bd9103fe6e60a774ec96a8c374744eef9197f6043075afa"
  license "GPL-2.0-or-later"
  revision 1

  livecheck do
    url :stable
    regex(%r{url=.*?/openocd[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 arm64_tahoe:    "2f69ce7044f8af47279213325e0e46feae77ec451c1d0277a2619f62f4f3c370"
    sha256 arm64_sequoia:  "68476caa858a611c3026458d2d00620c5b9eddcdcf63f6d36e06ca89b6734d15"
    sha256 arm64_sonoma:   "e1a4ef8fa11556dab2833bd52a179e3160a7f077816c7eed9ebe903d19509885"
    sha256 arm64_ventura:  "2af95c6cc37afdc18ec4fad86060a994e8fb79def599b0f0e2dab8472b4c0f0a"
    sha256 arm64_monterey: "29b4d09a5999e066c06aad94032162d13a020aa52a1d64b6b57114cab9ad4d2a"
    sha256 arm64_big_sur:  "8999e49e8e2c65a70f998e45d1ead00a9621adac26ffe93dfbf9cd712f714e51"
    sha256 sonoma:         "e757c2d3988325ebc500d2226f2e81f56a7ff73a4e1e435487c0d14f3a5e31a3"
    sha256 ventura:        "daa9924f73a731d961f1df6f2b7795324253cbfe73bf8e68f6d823d0753268c3"
    sha256 monterey:       "73a336499271b64f2cab04242346b9c4cd9314d3583a3992d3f6e8df2ac9573f"
    sha256 big_sur:        "1803ee897c13d4aefbdf87e845e06b5b4f0c2adeb6bfd11c24ed6ef1997af454"
    sha256 arm64_linux:    "0dd5d6c05b98f949a9fdd11a83de25df223bf8848d3e070c68d4a2b0a8095d9d"
    sha256 x86_64_linux:   "d912d763421e62bcd0a860b392e48f0d4ceda88c3020394ed054b90ad78f4466"
  end

  head do
    url "https://github.com/openocd-org/openocd.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "jimtcl" => :build
    depends_on "libtool" => :build
    depends_on "texinfo" => :build
  end

  depends_on "pkgconf" => :build
  depends_on "capstone"
  depends_on "hidapi"
  depends_on "libftdi"
  depends_on "libusb"

  def install
    ENV["CCACHE"] = "none"

    system "./bootstrap", "nosubmodule" if build.head?
    system "./configure", "--enable-buspirate",
                          "--enable-stlink",
                          "--enable-dummy",
                          "--enable-jtag_vpi",
                          "--enable-remote-bitbang",
                          *std_configure_args
    system "make", "install"
  end
end
