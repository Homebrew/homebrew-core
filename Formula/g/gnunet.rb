class Gnunet < Formula
  desc "Framework for distributed, secure and privacy-preserving applications"
  homepage "https://gnunet.org/"
  url "https://ftpmirror.gnu.org/gnu/gnunet/gnunet-0.25.1.tar.gz"
  mirror "https://ftp.gnu.org/gnu/gnunet/gnunet-0.25.1.tar.gz"
  sha256 "21336c16cd57f91f9d5fd5359482d9151a7cdf0d6396f8b61828c17ccc668f5c"
  license "AGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "8e691b8d922c37a3b434adda4ca90e85e7c317e1b318e21dc704aa7f9bbf8c91"
    sha256 cellar: :any, arm64_sequoia: "903a3d431aa96a417b49a96edbcd91282e471d86a15a9fe87d4610fe1b3f5544"
    sha256 cellar: :any, arm64_sonoma:  "e9b063e45e34cb595c85ddc70d0b12273a5bfe3163aec2f709a662c7841de0f7"
    sha256 cellar: :any, sonoma:        "34d71b81d39938ec4ab3a136e6b0a2c6d9a41c04fdef32f0fe46e2594a883973"
    sha256               arm64_linux:   "1aa5aff2a1bb010564378fb180e0e8585c07ef6b704efb5bb0cf99956f950d2b"
    sha256               x86_64_linux:  "c690218d288122f24cffa27fff82a4d49a864eecd15f6573628f228f9397736e"
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
    # Workaround for incomplete const change which only modified declaration
    # https://git.gnunet.org/gnunet.git/commit/src/include/gnunet_testing_lib.h?id=9ac6841eadc9f4b3b1e71e2ec08e75d94e851149
    files = ["src/lib/testing/testing_api_cmd_finish.c", "src/lib/testing/testing_api_cmd_exec.c"]
    inreplace files, /\bconst struct GNUNET_TESTING_Command\b/, "struct GNUNET_TESTING_Command"

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
