class Gnunet < Formula
  desc "Framework for distributed, secure and privacy-preserving applications"
  homepage "https://gnunet.org/"
  url "https://ftpmirror.gnu.org/gnu/gnunet/gnunet-0.29.0.tar.gz"
  mirror "https://ftp.gnu.org/gnu/gnunet/gnunet-0.29.0.tar.gz"
  sha256 "c27055165d347388dd487a07d7d131506cae2eeca5ee2d49cfcccada1ac29acc"
  license "AGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "513e270330d0c56631842589d582ab4a072cbcce68a6125704970c14e22a725a"
    sha256 cellar: :any, arm64_sequoia: "a16011195aae1fbfde5459847c841a0dc3c8484f238a4af7c8005ddbf11f80de"
    sha256 cellar: :any, arm64_sonoma:  "16bf3f20c41059221006cefcdd8b3ec43e5afd10301b6ab283dfaa360e9d026d"
    sha256 cellar: :any, sonoma:        "1ec97c87af9ac2e8ef40b4331e5b77e83ef59e13d33e92bc3c7455a8bbf5661d"
    sha256               arm64_linux:   "33d82b9f1fa3f52a2c9e384dd3b1abad20608f724b057f97d446583689a71132"
    sha256               x86_64_linux:  "9afd0a258c95b2ba102e1f265739585dcb47a6d303a8f21874409af9e84b9da4"
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
