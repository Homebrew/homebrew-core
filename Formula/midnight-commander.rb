class MidnightCommander < Formula
  desc "Terminal-based visual file manager"
  homepage "https://www.midnight-commander.org/"
  url "https://www.midnight-commander.org/downloads/mc-4.8.18.tar.xz"
  sha256 "f7636815c987c1719c4f5de2dcd156a0e7d097b1d10e4466d2bdead343d5bece"

  head "https://github.com/MidnightCommander/mc.git"

  bottle do
    rebuild 1
    sha256 "e43fedc65c05ea7c79de7e861370f3f69ede6b721db29dbc77bd50b5a8e64f57" => :sierra
    sha256 "645437aeeac3ee18c74bdc580550c9a6ef93411adebcd068f1c4061ef2a5a643" => :el_capitan
    sha256 "b7efc5f7d40b2d76a701add5f5dff35b8e6718f09fe749eb72d6258e5616ed0c" => :yosemite
    sha256 "2b6b3fee4eb893e62900a048b080dfafa2a1f029a04b4cb251d9f35487d52bb9" => :mavericks
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
