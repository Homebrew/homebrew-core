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

  bottle do
    rebuild 1
    sha256 arm64_ventura:  "c611d6b6c9e57cb090035cb957b452df65f7cbc631efad899fb7ab41e1ea32e1"
    sha256 arm64_monterey: "7b08b217ff97444f3b1543efe5d94f5b48dcdd74ea501426d894490e76f06405"
    sha256 arm64_big_sur:  "7cdba4d5b4ac53b160be03c26f96f8f8d1d4963ff2abaac7c219bc9fee03b50a"
    sha256 ventura:        "f55c5f34b7842ba9529b93f83997e1e6abac12ca77cd67bb76df8029894473a5"
    sha256 monterey:       "5fe0d9ced9ebdac6350e56e4ef5594f4080ce2c81054fb0b5fb55eca99c75f24"
    sha256 big_sur:        "fb7fef372618e8b59b07016c380b727d61103ee67ad5b68811bcbcc1516b3a6d"
    sha256 x86_64_linux:   "0b26fad3eda406a9cb72f04943b43015371b8f224fc624347fd9616f2604ad9e"
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
