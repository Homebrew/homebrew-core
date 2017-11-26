class MidnightCommander < Formula
  desc "Terminal-based visual file manager"
  homepage "https://www.midnight-commander.org/"
  url "https://www.midnight-commander.org/downloads/mc-4.8.20.tar.xz"
  mirror "https://fossies.org/linux/misc/mc-4.8.20.tar.xz"
  sha256 "017ee7f4f8ae420a04f4d6fcebaabe5b494661075c75442c76e9c8b1923d501c"
  head "https://github.com/MidnightCommander/mc.git"

  bottle do
    sha256 "f439aa7d34c79e6424944521a2937aee4128bce6fea2cfcebdd50b65111cee42" => :high_sierra
    sha256 "f1e01d6ae2d51af1958e327cbd6a0ab18a8e501737359c8e7ff47857de44427a" => :sierra
    sha256 "b3f82008e40f490866be7a57c754cd66f8130c97885c8a919af0e6606d4ec370" => :el_capitan
    sha256 "1486ddf0792621dbbf7b914e02c60b0248098e43046f8a106014e34d3c1f7181" => :yosemite
  end

  option "without-nls", "Build without Native Language Support"

  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "openssl"
  depends_on "s-lang"
  depends_on "libssh2"

  conflicts_with "minio-mc", :because => "Both install a `mc` binary"

  def install
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
      --without-x
      --with-screen=slang
      --enable-vfs-sftp
    ]

    # Fix compilation bug on macOS 10.13 by pretending we don't have utimensat()
    # https://github.com/MidnightCommander/mc/pull/130
    ENV["ac_cv_func_utimensat"] = "no" if MacOS.version >= :high_sierra

    args << "--disable-nls" if build.without? "nls"

    system "./configure", *args
    system "make", "install"
  end

  test do
    assert_match "GNU Midnight Commander", shell_output("#{bin}/mc --version")
  end
end
