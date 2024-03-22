class Powerman < Formula
  desc "Control (remotely and in parallel) switched power distribution units"
  homepage "https://github.com/chaos/powerman"
  url "https://github.com/chaos/powerman/releases/download/v2.4.0/powerman-2.4.0.tar.gz"
  sha256 "ff5f66285e1d952b4dbcb9543ef7969bb4abb464276aaecff949f629b72da605"
  license "GPL-2.0-or-later"

  bottle do
    sha256 arm64_sonoma:   "a8fa15a90e5cc08a7de1fe4dfe6dc133fcb10a5b09805dba8469fbc21540f524"
    sha256 arm64_ventura:  "a115d18e912395032621bd18c999cdc9d7e8c26db25d2ec9edc9e4671fca98bd"
    sha256 arm64_monterey: "c46634314ffb18a7996594ed70042647e36905ec82699326cb1169f0cae24e90"
    sha256 sonoma:         "703dcdd192d8298cf131be7e2a37b56951c3bc90af83aeed23a2a9d3e837b4e1"
    sha256 ventura:        "712822df74a50547e54e9f2e37e09152d4a2f8d0c02ec35f176dbba1a08e1c3a"
    sha256 monterey:       "0444ee3669a06de1b94748f429cb15ef1288617fc485b319f5e74c29bd2b2ca8"
    sha256 x86_64_linux:   "8e606ba2ca486f8299f73a11c580faf81abc84945dc51d8e21710e7e5e91bc97"
  end

  head do
    url "https://github.com/chaos/powerman.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "curl"

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
