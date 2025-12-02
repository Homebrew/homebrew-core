class Gnunet < Formula
  desc "Framework for distributed, secure and privacy-preserving applications"
  homepage "https://gnunet.org/"
  url "https://ftpmirror.gnu.org/gnu/gnunet/gnunet-0.26.1.tar.gz"
  mirror "https://ftp.gnu.org/gnu/gnunet/gnunet-0.26.1.tar.gz"
  sha256 "edd293be045649ac06227b019d5105cac677fc7caacafc951444c15cb2ba4c45"
  license "AGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "8ff9f7e9a7ec50cfd65ca12bb71188682b3c022193fb2db01999abe6fe17dcaf"
    sha256 cellar: :any, arm64_sequoia: "da248b311db3dc20b9912f0a65a80cef29be3ea1e2ecbc677de34e2f6857d559"
    sha256 cellar: :any, arm64_sonoma:  "56d0ca65c4a56a5866cfebd72b402788f689f8b17c159461d7e6b32780843064"
    sha256 cellar: :any, sonoma:        "fb7f676c3f75cd7aad9abf8836069b0011c656f2c449f0a6f87e410b75f01cdd"
    sha256               arm64_linux:   "8f78c3453e75ce0ee17ef5a1be8905ab5a63554e00e1a5cca3224b4fae6c0032"
    sha256               x86_64_linux:  "de4ea0a6b646c1eefcd75cd77226260b591d29e7cf823fef0404236eb9e2adba"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "gettext"
  depends_on "gmp"
  depends_on "gnutls"
  depends_on "jansson"
  depends_on "libextractor"
  depends_on "libgcrypt"
  depends_on "libidn2"
  depends_on "libmicrohttpd"
  depends_on "libsodium"
  depends_on "libtool"
  depends_on "libunistring"

  uses_from_macos "curl", since: :ventura # needs curl >= 7.85.0
  uses_from_macos "sqlite"
  uses_from_macos "zlib"

  on_macos do
    depends_on "libgpg-error"
  end

  def install
    # Workaround for htobe64 added to macOS 26 SDK until upstream updates
    # https://git.gnunet.org/gnunet.git/plain/src/include/gnunet_common.h
    ENV.append_to_cflags "-include sys/endian.h" if OS.mac? && MacOS.version >= :tahoe

    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"gnunet.conf").write <<~EOS
      [arm]
      START_DAEMON = YES
      START_SERVICES = "dns,hostlist,ats"
    EOS

    system bin/"gnunet-arm", "-c", "gnunet.conf", "-s"
  end
end
