class Libimobiledevice < Formula
  desc "Library to communicate with iOS devices natively"
  homepage "https://www.libimobiledevice.org/"
  url "https://github.com/libimobiledevice/libimobiledevice/releases/download/1.3.0/libimobiledevice-1.3.0.tar.bz2"
  sha256 "53f2640c6365cd9f302a6248f531822dc94a6cced3f17128d4479a77bd75b0f6"
  license "LGPL-2.1-or-later"
  revision 2

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma:   "85985aec074ff93af5e5a4196bf3b7116295a4e92243ad9142b9fac2aaa04437"
    sha256 cellar: :any,                 arm64_ventura:  "a0b73ca987a26248dc64272e34ed2db70156a69f4ff822b9a4fe4469f2df58e5"
    sha256 cellar: :any,                 arm64_monterey: "d0171cc0d5732ee715abf3bbe7dd92efba8bf88279f60482ff8986ae6cdbde8d"
    sha256 cellar: :any,                 arm64_big_sur:  "1e4917ae5796b18ca5ea5e38b85d47d675d3c6c9bdc48e2e1d003f4ff6c19540"
    sha256 cellar: :any,                 sonoma:         "dad83fc3686772077306929ccfcfd873d2318c5ff5e522e0933a25640084cb03"
    sha256 cellar: :any,                 ventura:        "5144c615b915468129a13abfab256335f1f730f8bbfcf516c6c2cc237a0ba762"
    sha256 cellar: :any,                 monterey:       "1d903432f3155c8092eb953e7bcacf878916c746d512edeaa9535e81cd066a44"
    sha256 cellar: :any,                 big_sur:        "2dcb57cf62ed6ee21b73c7281435bf780f7bb5b6a977721ed486a292dab20828"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0c1d8bbe78dd8255dc555755f5900b47df680785923dd62ceb26512d506cba0e"
  end

  # libimobiledevice-glue is required for building future versions
  # Move outside of HEAD clause when there's a new release.
  head do
    url "https://github.com/libimobiledevice/libimobiledevice.git", branch: "master"
    depends_on "libimobiledevice-glue"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "libplist"
  depends_on "libtasn1"
  depends_on "libusbmuxd"
  depends_on "openssl@3"

  def install
    # Make libimobiledevice work with libplist 2.3.0
    # Remove this once libimobiledevice gets a new release
    inreplace "common/utils.h", "PLIST_FORMAT_XML", "PLIST_FORMAT_XML_" if build.stable?
    inreplace "common/utils.h", "PLIST_FORMAT_BINARY", "PLIST_FORMAT_BINARY_" if build.stable?

    # As long as libplist builds without Cython bindings,
    # so should libimobiledevice as well.
    args = %w[
      --disable-silent-rules
      --without-cython
      --enable-debug
    ]

    system "./autogen.sh", *std_configure_args, *args if build.head?
    system "./configure", *std_configure_args, *args if build.stable?
    system "make", "install"
  end

  test do
    system "#{bin}/idevicedate", "--help"
  end
end
