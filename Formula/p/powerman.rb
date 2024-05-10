class Powerman < Formula
  desc "Control (remotely and in parallel) switched power distribution units"
  homepage "https://github.com/chaos/powerman"
  url "https://github.com/chaos/powerman/releases/download/v2.4.2/powerman-2.4.2.tar.gz"
  sha256 "8465d1669745a72e3822fdc73f3e4a06737d8579a59190fef0b8aa259d7fc13f"
  license "GPL-2.0-or-later"

  bottle do
    sha256 arm64_sonoma:   "449897522c30bbf6038ec585e5468431a9375b7c60181cc69205f3e32727d6c8"
    sha256 arm64_ventura:  "b2575429a427c64419b73cec8cfefd025c5c63115a5bd9fc74591dcb1472d6f0"
    sha256 arm64_monterey: "1b34a44d3c1b602cc3f626202599fc35da5227625a114f197c6a8b4851b27502"
    sha256 sonoma:         "bedfb4bc34c7a486261dec7d938e161e468bfd1306d6faa19ef119105766b71e"
    sha256 ventura:        "ff90dab0175a46c5d69fc7fcf2f496e3f2bc7cd2d6bcbec995cfd224af552f6d"
    sha256 monterey:       "41364ffc8b3ad19c29757b462b15955c46884f20030c1b704499045f81d5f961"
    sha256 x86_64_linux:   "6337235e996ed7cf93257f77da3788f6a0bb61e707cdb5e016736fe2063d345e"
  end

  head do
    url "https://github.com/chaos/powerman.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "curl"
  depends_on "jansson"

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--localstatedir=#{var}",
                          "--with-httppower",
                          "--with-ncurses",
                          "--without-genders",
                          "--without-snmppower",
                          "--without-tcp-wrappers"
    system "make", "install"
  end

  test do
    system "#{sbin}/powermand", "-h"
  end
end
