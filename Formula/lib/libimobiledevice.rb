class Libimobiledevice < Formula
  desc "Library to communicate with iOS devices natively"
  homepage "https://www.libimobiledevice.org/"
  url "https://github.com/libimobiledevice/libimobiledevice/releases/download/1.3.0/libimobiledevice-1.3.0.tar.bz2"
  sha256 "53f2640c6365cd9f302a6248f531822dc94a6cced3f17128d4479a77bd75b0f6"
  license "LGPL-2.1-or-later"
  revision 3

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "9bc550fcfb5ee4613073831691cda4cc54a88180e833a0f754886f1a34af4134"
    sha256 cellar: :any,                 arm64_sonoma:  "2fc25461e9305a7cadd0ec50326048641a67a6231d73a4ccf69e0d90c4783a19"
    sha256 cellar: :any,                 arm64_ventura: "7017a85a4322e960abb9cc122ed45cf159eddc90c45a30d4a24aef14173ea0c6"
    sha256 cellar: :any,                 sonoma:        "7ca1985300a97b783b50752ff9110cb9b02dc7d278a62451b36fa5b98d359708"
    sha256 cellar: :any,                 ventura:       "c811173f433f58df573afeb557308c55be71309442e6088f0b2b93cafffb39cb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "871739207d85ff9dafe6c8f24f7ac24242216bc6154ed5d3b0c8e238ab62f24a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d38d4434dc756c8153d4a0ed23ba0e68c643c7e9e1086cf08c5497700867cdb4"
  end

  # libimobiledevice-glue is required for building future versions
  # Move outside of HEAD clause when there's a new release.
  head do
    url "https://github.com/libimobiledevice/libimobiledevice.git", branch: "master"
    depends_on "libimobiledevice-glue"
    depends_on "libtatsu"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build
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

    configure = build.head? ? "./autogen.sh" : "./configure"
    system configure, *args, *std_configure_args
    system "make", "install"
  end

  test do
    system bin/"idevicedate", "--help"
  end
end
