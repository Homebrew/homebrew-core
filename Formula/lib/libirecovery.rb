class Libirecovery < Formula
  desc "Library and utility to talk to iBoot/iBSS via USB"
  homepage "https://www.libimobiledevice.org/"
  url "https://github.com/libimobiledevice/libirecovery/releases/download/1.2.1/libirecovery-1.2.1.tar.bz2"
  sha256 "d25f4b85c24df206efbbbd2d6d45d1637229e756c52d535eef047a163799f67c"
  license "LGPL-2.1-only"
  head "https://github.com/libimobiledevice/libirecovery.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "1fa2418a0a22032fd7a150b6f19794e3eeb17841912d6603e71ac16d312df6f3"
    sha256 cellar: :any,                 arm64_sonoma:  "7484a2a971dfbb544af0c0247b2c14991fae187b8d4c620871964a6fb7a66b76"
    sha256 cellar: :any,                 arm64_ventura: "f94d490451247969eafd81875cce5b9d2e6274eaa3472c1ec70e7fbad57cb73c"
    sha256 cellar: :any,                 sonoma:        "27ea53a0973bb2a7505d76db3fbf279b12f470b4f32066af6f0162d2c00e7e6b"
    sha256 cellar: :any,                 ventura:       "04164267c7cb92582d2c210db13e68c3963d233120d173931f2b875bd0faef69"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ae625c342c140f8607eee693da903c59dede5ebb061461061ded9cda7503af9c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "81f40f20b147feba73637419fb12cf88172b82675ec8bc9ca396182505040a85"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build
  depends_on "libimobiledevice-glue"

  on_macos do
    depends_on "libplist"
  end

  on_linux do
    depends_on "libusb"
    depends_on "readline"
  end

  def install
    configure = build.head? ? "./autogen.sh" : "./configure"
    system configure, "--disable-silent-rules", *std_configure_args
    system "make", "install"
  end

  test do
    assert_match "ERROR: Unable to connect to device", shell_output("#{bin}/irecovery -f nothing 2>&1", 255)
  end
end
