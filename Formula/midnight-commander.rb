class MidnightCommander < Formula
  desc "Terminal-based visual file manager"
  homepage "https://www.midnight-commander.org/"
  url "https://www.midnight-commander.org/downloads/mc-4.8.19.tar.xz"
  mirror "https://fossies.org/linux/misc/mc-4.8.19.tar.xz"
  sha256 "eb9e56bbb5b2893601d100d0e0293983049b302c5ab61bfb544ad0ee2cc1f2df"
  head "https://github.com/MidnightCommander/mc.git"

  bottle do
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

    args << "--disable-nls" if build.without? "nls"

    system "./configure", *args
    system "make", "install"
  end

  test do
    assert_match "GNU Midnight Commander", shell_output("#{bin}/mc --version")
  end
end
