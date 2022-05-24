class OpenOcd < Formula
  desc "On-chip debugging, in-system programming and boundary-scan testing"
  homepage "https://openocd.org/"
  url "https://downloads.sourceforge.net/project/openocd/openocd/0.11.0/openocd-0.11.0.tar.bz2"
  sha256 "43a3ce734aff1d3706ad87793a9f3a5371cb0e357f0ffd0a151656b06b3d1e7d"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(%r{url=.*?/openocd[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_monterey: "c9d4a7541767a76b5f588b30a188422c546d731d2786369d53a9458661879343"
    sha256 arm64_big_sur:  "c95313b03e7050963f4a35a28e88743cd01d1a5e198f809e60ac9e3374799995"
    sha256 monterey:       "dfb1540fd17932f3f081c6c10b320a9794ee2ab498b4e869d211092cb594c820"
    sha256 big_sur:        "8c776e777a2587d45f7abc2ab9cb3d682a9e1d0c186c16d3beeec4b5dddcc637"
    sha256 catalina:       "70eeaab9796e8356a5ad08c8f69e9fc7a86f9ef3f7060248ab49722dfeb95794"
    sha256 mojave:         "31773a9703e8b217b5d6dc58dc670a8f8afd2b51e7735bbd499eef2daad357dd"
    sha256 x86_64_linux:   "7a1e636fc79b084859ad0a60a6a8bcd358f190b7381e9bb8fc3c8c8823978fb8"
  end

  head do
    url "https://github.com/openocd-org/openocd.git"

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
  depends_on "libusb-compat"

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
