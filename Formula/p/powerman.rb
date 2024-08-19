class Powerman < Formula
  desc "Control (remotely and in parallel) switched power distribution units"
  homepage "https://github.com/chaos/powerman"
  url "https://github.com/chaos/powerman/releases/download/v2.4.3/powerman-2.4.3.tar.gz"
  sha256 "a6a3e1221fd89f9470651e87f95bd6515628aba49548dc8542f31db7a6515f77"
  license "GPL-2.0-or-later"

  bottle do
    sha256 arm64_sonoma:   "4ded224dcefa7bcd8cf88f3c2c361c3b4fde34e2739a230671fbbffcc1115921"
    sha256 arm64_ventura:  "0f6aa7fdc471762140bd9485f93e466bfe1fb17b1737963f1e42e163365a392b"
    sha256 arm64_monterey: "3da5b7a83bd6406fb856c62eed30ff3864d23c5d98f0ae4495bc058412a84752"
    sha256 sonoma:         "36824e6553bb800aa748e95b12fe8c5807906737f608841d58d657d026f0c1e2"
    sha256 ventura:        "946f99d1cf3388b604f313b859e2b070110bac55a90acc52e8d42865a6b719d4"
    sha256 monterey:       "c61f02cd33ea47dccaa4e9d631e2cea5939035db8f817811761286956e3cac84"
    sha256 x86_64_linux:   "df224350c628e8c2311973ef8e72ddbfa92f13151babef1a7dd3edfafad8ca92"
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
