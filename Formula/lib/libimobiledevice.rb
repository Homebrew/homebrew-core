class Libimobiledevice < Formula
  desc "Library to communicate with iOS devices natively"
  homepage "https://www.libimobiledevice.org/"
  url "https://github.com/libimobiledevice/libimobiledevice/releases/download/1.3.0/libimobiledevice-1.3.0.tar.bz2"
  sha256 "53f2640c6365cd9f302a6248f531822dc94a6cced3f17128d4479a77bd75b0f6"
  license "LGPL-2.1-or-later"
  revision 3

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "f496e32077cc020a7ffcb6a6afee3034fc4c55ced685ba0b2155c0355bbf7a95"
    sha256 cellar: :any,                 arm64_ventura:  "c0f9da975e59842256875121304fdb0825909f3c43b8cf1271b505cd7436955e"
    sha256 cellar: :any,                 arm64_monterey: "b465efbb59cafd4d9ea16cefd5b0d33c1411da49855e14b5864ce139b65df8c6"
    sha256 cellar: :any,                 sonoma:         "dfcb200312b7e57c99699a47ffc0ed522f3fe4d1913037003b706fe545daa082"
    sha256 cellar: :any,                 ventura:        "a91555bb6c89202bbb68d84bfe425aeb63c50d4001c310d39643637d93bde290"
    sha256 cellar: :any,                 monterey:       "aa17026544ec683e544113478c07c1d387e3566d949c32834b083ad72042be16"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c418aa763659463002269201586cd356c69e6a233b2040ced02a352498b362d8"
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
