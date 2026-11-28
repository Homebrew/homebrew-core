class Libimobiledevice < Formula
  desc "Library to communicate with iOS devices natively"
  homepage "https://www.libimobiledevice.org/"
  license "LGPL-2.1-or-later"
  revision 3
  compatibility_version 1
  head "https://github.com/libimobiledevice/libimobiledevice.git", branch: "master"

  stable do
    url "https://github.com/libimobiledevice/libimobiledevice/releases/download/1.4.0/libimobiledevice-1.4.0.tar.bz2"
    sha256 "23cc0077e221c7d991bd0eb02150a0d49199bcca1ddf059edccee9ffd914939d"

    # Backport fix for an unbounded memory leak in the ostrace code path.
    # https://github.com/libimobiledevice/libimobiledevice/issues/1677
    patch do
      url "https://github.com/libimobiledevice/libimobiledevice/commit/5ca453f9e3950b1f24b51e4cdf255236e34254c4.patch?full_index=1"
      sha256 "f77230cd1be4b483e0e0bc1273c25a273fb3845d7e65831f0b62d1a5f0f01a83"
      type :backport
      resolves "https://github.com/libimobiledevice/libimobiledevice/issues/1677"
    end
  end

  bottle do
    manifest_sha256 "1705e7586da22d7afa41d44872c7e0aa4a07820540d32ddaf4c1b6f6244baab6"
    sha256 cellar: :any, arm64_golden_gate: "bc7cae16faf4ddedf0d6c75652bf0c82dd674fe96ed601917aaa3e70a714b549"
    sha256 cellar: :any, arm64_tahoe:       "2d6452378134837c5948786665ae1084b73e26cc63ca7038775b8c8a63f0587e"
    sha256 cellar: :any, arm64_sequoia:     "0dbe0bb370482fac0ab4198e5b0bf8b12dd81aebdfcd5bea9245987cf8054a9f"
    sha256 cellar: :any, arm64_linux:       "4b58c01ae36e0a0ec96ed195ae542a3e495b3b4818b4940a8dfa4447a61ba02a"
    sha256 cellar: :any, x86_64_linux:      "4ea9919dd1a53b560232ad9e9c8a955b4c6735dc2e24bcde616dc52342aec0df"
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
