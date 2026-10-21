class Libimobiledevice < Formula
  desc "Library to communicate with iOS devices natively"
  homepage "https://www.libimobiledevice.org/"
  url "https://github.com/libimobiledevice/libimobiledevice/releases/download/1.4.0/libimobiledevice-1.4.0.tar.bz2"
  sha256 "23cc0077e221c7d991bd0eb02150a0d49199bcca1ddf059edccee9ffd914939d"
  license "LGPL-2.1-or-later"
  revision 2
  compatibility_version 1
  head "https://github.com/libimobiledevice/libimobiledevice.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "bd24e96b92bdb9ea209c4231630bdbbbd087627555987cdebaf6ccfe8d0aaa3a"
    sha256 cellar: :any, arm64_tahoe:       "967bd0bdccbd984f218e08c60fc3777def033a62252bd2b61ec6a37a77ad25cd"
    sha256 cellar: :any, arm64_sequoia:     "7d80544bfe2cc2cc0f34865ffdb19d741b61d5162d520ade2a11e1e3999c630c"
    sha256 cellar: :any, arm64_linux:       "94f1ff2abef7d2a468375c125f2e106b9d24631a1c5226bfff8215372a2c43bb"
    sha256 cellar: :any, x86_64_linux:      "0cf6b1d55bd0dbb4c1cf7114cac78c0607e53e811e9c693f2ebb51a411bd2a43"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build
  depends_on "libimobiledevice-glue"
  depends_on "libplist"
  depends_on "libtasn1"
  depends_on "libtatsu"
  depends_on "libusbmuxd"
  depends_on "openssl@4"

  on_linux do
    depends_on "readline"
  end

  deny_network_access!

  def install
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
