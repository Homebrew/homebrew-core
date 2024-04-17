class Powerman < Formula
  desc "Control (remotely and in parallel) switched power distribution units"
  homepage "https://github.com/chaos/powerman"
  url "https://github.com/chaos/powerman/releases/download/v2.4.1/powerman-2.4.1.tar.gz"
  sha256 "e91c88e87d1bfe5d578ff6ebadce9f89f1b6934dac14526175ba8add53ea5053"
  license "GPL-2.0-or-later"

  bottle do
    sha256 arm64_sonoma:   "ce71983e664c4dcf4ea1671dedc515f536960dd36c8e84ae074bc50604428c5f"
    sha256 arm64_ventura:  "196bfc868204f245d9043576e958410cba83b720089b125f61d0593eed3a16a2"
    sha256 arm64_monterey: "180a4d1659974a9f5c276253c95d1b524a28c219d6a9a5217f24769e3b4f3ac7"
    sha256 sonoma:         "ba39b4190e33052c7cab5565f48da4f0fbdf4df9d1265de278c5b7417b403cb1"
    sha256 ventura:        "0429fc87ef36713a4c9dfa7d329d9b997c8ea6bcbe6717b0aaa8f13fe801a1a6"
    sha256 monterey:       "130ddcaab942afdbf18a47bb14dc509b37c3d1dcfb181683150f96b0200e76f9"
    sha256 x86_64_linux:   "b8b7d2d665d0f69b46ccdf00282aaf6db71e91ce22589772a0ddeedd23031538"
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
