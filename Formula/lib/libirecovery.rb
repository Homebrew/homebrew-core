class Libirecovery < Formula
  desc "Library and utility to talk to iBoot/iBSS via USB"
  homepage "https://www.libimobiledevice.org/"
  url "https://github.com/libimobiledevice/libirecovery/releases/download/1.2.0/libirecovery-1.2.0.tar.bz2"
  sha256 "74448348f8a68b654015fe1952fdc4e0781db20dcf4e1d85ec97d6f91e95eb14"
  license "LGPL-2.1-only"
  head "https://github.com/libimobiledevice/libirecovery.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "8e33848346905d014f7196a8ff5a7ec4fd07aa2df634b9d644e70e16d9a6ec82"
    sha256 cellar: :any,                 arm64_ventura:  "baf684cbb170ca1dd6a667b151bee4eb8225e29a0db24f7fc8fa646fafd67b74"
    sha256 cellar: :any,                 arm64_monterey: "10a72e5bc74f8b6b12146cc27546a708c5b402ee52360358ac3e00e001dced85"
    sha256 cellar: :any,                 sonoma:         "c9a4575f92626ebc8bc6d52fdb169c26eefbafffbeb1dc55252e88bc19c05051"
    sha256 cellar: :any,                 ventura:        "f311a8460344860385ecf64e4022f4bf775e6ebaf9ab9f8d24ca10a22513e4f3"
    sha256 cellar: :any,                 monterey:       "7b846f671bc3566d8cb556e015c29458c093afd5830c30351ac2d44ad45b29eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3c01e6062a8da402b79cc561d6fd4687005b55ce5b4456030e45275accd8eb00"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "libimobiledevice-glue"

  on_linux do
    depends_on "libusb"
    depends_on "readline"
  end

  def install
    if build.head?
      system "./autogen.sh", *std_configure_args, "--disable-silent-rules"
    else
      system "./configure", *std_configure_args, "--disable-silent-rules"
    end
    system "make", "install"
  end

  test do
    assert_match "ERROR: Unable to connect to device", shell_output("#{bin}/irecovery -f nothing 2>&1", 255)
  end
end
