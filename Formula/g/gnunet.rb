class Gnunet < Formula
  desc "Framework for distributed, secure and privacy-preserving applications"
  homepage "https://gnunet.org/"
  url "https://ftpmirror.gnu.org/gnu/gnunet/gnunet-0.25.0.tar.gz"
  mirror "https://ftp.gnu.org/gnu/gnunet/gnunet-0.25.0.tar.gz"
  sha256 "2dea662ee8605946852af02d2806ca64fdadedcc718eeef6b86e0b26822c36ff"
  license "AGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "2cb19f64d4050d97774379dd8558fd5a8747d0341f3e85690cccb34c28a8b278"
    sha256 cellar: :any, arm64_sequoia: "8e41b13d2d2c917a76eef70ae7730094152050c956b27eecb5b9767f0850d5b4"
    sha256 cellar: :any, arm64_sonoma:  "42ec103b0d30355d32c2bfd66bb77d46b2c708c0c91697c9aa0493cae63aaf68"
    sha256 cellar: :any, sonoma:        "559f0db32a4e4adf572874d6aaea9f77e9eff6f6590cb674128417a338e31c5b"
    sha256               arm64_linux:   "d5f6b888f94a3297441bccab6fd2c4d12c0e9b792a729670c8ea9c5f289b81ff"
    sha256               x86_64_linux:  "af830e8d5274ca00ac1d08e23c0c4d2cbea37bae6bdfc73d6d2fa5d2931d5430"
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
