class Gnunet < Formula
  desc "Framework for distributed, secure and privacy-preserving applications"
  homepage "https://gnunet.org/"
  url "https://ftpmirror.gnu.org/gnu/gnunet/gnunet-0.28.0.tar.gz"
  mirror "https://ftp.gnu.org/gnu/gnunet/gnunet-0.28.0.tar.gz"
  sha256 "9f51cd2d713aa8ed41bc503bccb721959302c2e93df1464f6ce70d664d9c889d"
  license "AGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "0dc1c7dc1120d61232c163716834422645f75683d8008e025deb03c80ac19404"
    sha256 cellar: :any, arm64_sequoia: "ee4cafb05231a7e2080f80e42975dd366bf90929c55e04bb4ba3d790db05a6ca"
    sha256 cellar: :any, arm64_sonoma:  "f69075f1383e4bfae59ec9afeac110193416cc50a7a82a9cbde9e9471f602282"
    sha256 cellar: :any, sonoma:        "814c1162dfb3250e9072cf7679352b83e529f735f6ae4620ec862042c760c4a0"
    sha256               arm64_linux:   "caa9d922c870d5af4353a3f0e896b690b4f7c88d5a924e664db537115b5af9f6"
    sha256               x86_64_linux:  "96fcc041f1dfc37a7dc8ee22850d2c038cd942b9a8f17ac4972164f1b4ebafd2"
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
