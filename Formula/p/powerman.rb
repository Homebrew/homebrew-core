class Powerman < Formula
  desc "Control (remotely and in parallel) switched power distribution units"
  homepage "https://github.com/chaos/powerman"
  url "https://github.com/chaos/powerman/releases/download/v2.4.4/powerman-2.4.4.tar.gz"
  sha256 "d675502144bc0875def92dad4c0efc6d43bc81c78d6fdb09ebc5f3558b3b7c85"
  license "GPL-2.0-or-later"

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "88063926073d1f61aab9db6b965e65cc8d126d7521d0b563ae4232e88fb9392e"
    sha256 arm64_sequoia: "179d0cd8df9b000290df35c0b7d061cab03ff41db3bc68ec40128c7baac54a8f"
    sha256 arm64_sonoma:  "eea753232b6b35fd530d928e32947bbddf17db61492bf64ab15e197c92e899df"
    sha256 sonoma:        "adcf3f23bf67cfff2c9dad9f871c6ac4aea835e2bcc1fbd6b9efcdf8a24db431"
    sha256 arm64_linux:   "b848eb9847153385438f8c7bed8f72ad8a265a9204e5b1e3e07e515bbc094aa1"
    sha256 x86_64_linux:  "312e00a08663449257f384d818b56cfd4fb147951280764dae0bc039792366ec"
  end

  head do
    url "https://github.com/chaos/powerman.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "jansson"

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build
  uses_from_macos "curl"

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--localstatedir=#{var}",
                          "--with-httppower",
                          "--with-ncurses",
                          "--without-genders",
                          "--without-snmppower",
                          "--without-tcp-wrappers",
                          *std_configure_args
    system "make", "install"
  end

  test do
    system sbin/"powermand", "-h"
  end
end
