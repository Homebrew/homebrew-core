class Gnunet < Formula
  desc "Framework for distributed, secure and privacy-preserving applications"
  homepage "https://gnunet.org/"
  url "https://ftpmirror.gnu.org/gnu/gnunet/gnunet-0.26.2.tar.gz"
  mirror "https://ftp.gnu.org/gnu/gnunet/gnunet-0.26.2.tar.gz"
  sha256 "8fd2dc4e6eaac0dc8d828d4e2a5afc271bd77d2b820de2f0cba7589ab30ce46e"
  license "AGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "745b60dc91143a7bf3bf54910b06812b4e97d97a05123ea8416a00d8bb345c22"
    sha256 cellar: :any, arm64_sequoia: "42a83e9648276a12e3bd4636fdc96a86b1841ec5ff5e9789a6eb7e0fd312409e"
    sha256 cellar: :any, arm64_sonoma:  "2f43e93423c6c685429847b8acdcc255164b7be93419c429d950cc3db510e0e5"
    sha256 cellar: :any, sonoma:        "2f5cfe3cded73e0b021088c75650cf12b89e89599d1ad7a5d91be9672d7c0291"
    sha256               arm64_linux:   "c2d3eabe9e8c33588504e61e462c7df1104447de37641b7c966bec2e7445c0ce"
    sha256               x86_64_linux:  "7bd8dec99aad1a7e10c9a88935715f929819d59c5ec3955216400d1dfa52cd5c"
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
