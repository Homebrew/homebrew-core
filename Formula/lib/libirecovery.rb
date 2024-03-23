class Libirecovery < Formula
  desc "Library and utility to talk to iBoot/iBSS via USB"
  homepage "https://www.libimobiledevice.org/"
  url "https://github.com/libimobiledevice/libirecovery/releases/download/1.2.0/libirecovery-1.2.0.tar.bz2"
  sha256 "74448348f8a68b654015fe1952fdc4e0781db20dcf4e1d85ec97d6f91e95eb14"
  license "LGPL-2.1-only"
  head "https://github.com/libimobiledevice/libirecovery.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "c23a8f97819e0cb7267f87f7a7fba3489bf3ace8e1f5363f54ae71db07a73b22"
    sha256 cellar: :any,                 arm64_ventura:  "c89588a804efa11bf82de5bd11d5738d63ec6478a0df86c97a00b80d861d40a9"
    sha256 cellar: :any,                 arm64_monterey: "ee2d4d7c10f423211f90980a6f55579248276ebaebbdb9fdb54800d038ac2085"
    sha256 cellar: :any,                 arm64_big_sur:  "902972b9170d7e08d8a70b66eab35d9df76e1df27224cb946c0be1ef82353141"
    sha256 cellar: :any,                 sonoma:         "ee677db3095954a6a8343a70718a090df399087ce9dd5e235a938e30ae5654c7"
    sha256 cellar: :any,                 ventura:        "c881cbc03021cff9b80b52a336b7867fc84f5f8a0c7d708efc0b2d57b2c8d4bc"
    sha256 cellar: :any,                 monterey:       "482af86082c862c07c9cade9141d03316395a92280d30cad03d0c0a8ed6d9d15"
    sha256 cellar: :any,                 big_sur:        "7c106288f535b839fd97da078ef8dbb69274511ea79452f3a707aa4ff0513726"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ac0c82fcd09a664942244b49becd387b6d2754d1a39ddd6322471e5e3b2cc00a"
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
