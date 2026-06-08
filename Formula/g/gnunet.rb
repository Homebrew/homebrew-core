class Gnunet < Formula
  desc "Framework for distributed, secure and privacy-preserving applications"
  homepage "https://gnunet.org/"
  url "https://ftpmirror.gnu.org/gnu/gnunet/gnunet-0.27.0.tar.gz"
  mirror "https://ftp.gnu.org/gnu/gnunet/gnunet-0.27.0.tar.gz"
  sha256 "9dd8feb3f3b8d0993766a49ab618f80bb93017f3bc795b6dda84697397302a07"
  license "AGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "056d46173e490e99d20a9a745bc5aa663f9848cc06131ad6ecfa9b04b6ac6f59"
    sha256 cellar: :any, arm64_sequoia: "4ea40d021709b5effb91c1599c92cc61ed38db01c4ad9e20a99a2fb5ceddad12"
    sha256 cellar: :any, arm64_sonoma:  "39dffccef2f229ea2ee723bdaf15f9c35ca5ac97046bc302479a2b74c5a02fce"
    sha256 cellar: :any, sonoma:        "29c2c40b192f09055ce531bdf0959a570739cd0c2b704a4fcc6f6cb5385e92cf"
    sha256               arm64_linux:   "1af534f987e8bb580f89808a4e273da007d7d69baea284cb64d8ef278ea37273"
    sha256               x86_64_linux:  "2e09b29bffd50dc8efbb3c5c2a191ca72a6101a99f233c449b049aec20d7af95"
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

  on_macos do
    depends_on "libgpg-error"
  end

  on_linux do
    depends_on "zlib-ng-compat"
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
