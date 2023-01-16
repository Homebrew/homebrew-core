class OpenOcd < Formula
  desc "On-chip debugging, in-system programming and boundary-scan testing"
  homepage "https://openocd.org/"
  url "https://downloads.sourceforge.net/project/openocd/openocd/0.12.0/openocd-0.12.0.tar.bz2"
  sha256 "af254788be98861f2bd9103fe6e60a774ec96a8c374744eef9197f6043075afa"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(%r{url=.*?/openocd[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_ventura:  "f45c81b908590c4a6f14e41864079b9d5d15b30e5c3c0dc8fff116419629354c"
    sha256 arm64_monterey: "0f2c67a9ac1fbeedaecab8c7b28a13ad02b23b3f22f0291824536e6dfc0400f3"
    sha256 arm64_big_sur:  "10bc538f2fa15a6b5394d62a23a9791d11caf5220aee5977ad132c8e49d2383a"
    sha256 ventura:        "fc651defb7f42ba32d3f7879ecaea300045f19a686b1fe614e4d194dfde0b86a"
    sha256 monterey:       "b08e2fcad452c7b511c152c347f46879ad4818c74e84fc415a4ad6cdb57c8278"
    sha256 big_sur:        "f9c34229e17528c93e4297292cd51ed477096559d5b9661a52c7f040df0e0635"
    sha256 x86_64_linux:   "7360c435cdf6e48fd6310e203f0911ce90668ec918fbe60814b866048be60f66"
  end

  head do
    url "https://github.com/openocd-org/openocd.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
    depends_on "texinfo" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "capstone"
  depends_on "hidapi"
  depends_on "libftdi"
  depends_on "libusb"

  def install
    ENV["CCACHE"] = "none"

    system "./bootstrap", "nosubmodule" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-buspirate",
                          "--enable-stlink",
                          "--enable-dummy",
                          "--enable-jtag_vpi",
                          "--enable-remote-bitbang"
    system "make", "install"
  end
end
