class MidnightCommander < Formula
  desc "Terminal-based visual file manager"
  homepage "https://www.midnight-commander.org/"
  url "https://www.midnight-commander.org/downloads/mc-4.8.21.tar.xz"
  sha256 "8f37e546ac7c31c9c203a03b1c1d6cb2d2f623a300b86badfd367e5559fe148c"
  head "https://github.com/MidnightCommander/mc.git"

  bottle do
    sha256 "159211a47a8692577a2dac8252d78cd6e18138838e270ecc406ab88bb39ca0c6" => :mojave
    sha256 "a82ff8536b8e9427a4033ed485851341c7003c294a1aeba8dfe74410f5c2f33f" => :high_sierra
    sha256 "71401e028dcff038c22acced173c020003cb909fac46a5c33e45581665dc1da3" => :sierra
    sha256 "cf9e47ee1b5a3efbdc88f787496d0baaee65690f27e7cfafa031da2d51658792" => :el_capitan
  end

  option "without-nls", "Build without Native Language Support"

  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "libssh2"
  depends_on "openssl"
  depends_on "s-lang"

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
