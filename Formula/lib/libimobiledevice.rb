class Libimobiledevice < Formula
  desc "Library to communicate with iOS devices natively"
  homepage "https://www.libimobiledevice.org/"
  url "https://github.com/libimobiledevice/libimobiledevice/releases/download/1.4.0/libimobiledevice-1.4.0.tar.bz2"
  sha256 "23cc0077e221c7d991bd0eb02150a0d49199bcca1ddf059edccee9ffd914939d"
  license "LGPL-2.1-or-later"
  head "https://github.com/libimobiledevice/libimobiledevice.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "57e9ce8270a268ce61766da57305ddf8adef5310556992f97534a0c6b8dc2112"
    sha256 cellar: :any,                 arm64_sequoia: "17e3e2fa9618cfdc21a0e87c97ae8d1ffb02de19f88ef5cc886a0663b6c1b66c"
    sha256 cellar: :any,                 arm64_sonoma:  "ac0a39864d542e1b5d248efe7ee1bbb5dc58a2739dd248ec987dc7b794ef9fd9"
    sha256 cellar: :any,                 sonoma:        "aa40670dbbdadabc7f035fe2ea17da68a1dab8937a4f1c0429c0a7fd58c108f5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d54c686502da56b005f514e052d5d6f24242acc99236309da37854d573fd0206"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8d22c1f4fccc06261e4e1775f3d56864ddbe37ba3980b28b5d17898d74662307"
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
  depends_on "openssl@3"

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
