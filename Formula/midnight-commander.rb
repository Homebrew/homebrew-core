class MidnightCommander < Formula
  desc "Terminal-based visual file manager"
  homepage "https://www.midnight-commander.org/"
  url "https://www.midnight-commander.org/downloads/mc-4.8.20.tar.xz"
  mirror "https://fossies.org/linux/misc/mc-4.8.20.tar.xz"
  sha256 "017ee7f4f8ae420a04f4d6fcebaabe5b494661075c75442c76e9c8b1923d501c"
  head "https://github.com/MidnightCommander/mc.git"

  bottle do
    sha256 "38c3c19eb05df22c810264ea103e7e60fd68650786bf901cf23783a827fe36c1" => :high_sierra
    sha256 "9e1bbcf9abe4d17b332dad09be0f08539b94413e4030e02559c0505b4ae52076" => :sierra
    sha256 "48f79c9e813f528ca32070a6462c15250007ffa4006e5cc104ecfce51f09b8ea" => :el_capitan
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
