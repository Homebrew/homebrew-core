class OsinfoDbTools < Formula
  desc "Tools for managing the libosinfo database files"
  homepage "https://libosinfo.org/"
  url "https://releases.pagure.org/libosinfo/osinfo-db-tools-1.12.0.tar.xz"
  sha256 "f3315f675d18770f25dea8ed04b20b8fc80efb00f60c37ee5e815f9c3776e7f3"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://releases.pagure.org/libosinfo/?C=M&O=D"
    regex(/href=.*?osinfo-db-tools[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "80f2f1a41f22df092e66ad09f9859a2e8803624c721a35fb1ebfb8686f16c29f"
    sha256 arm64_sonoma:  "4e67be0abc92b903e05fe4f6f9a9ff4a184e2c389131867266514fa4133b99a8"
    sha256 arm64_ventura: "0290289cbf19411222251e9ddd30034f5eb3ef07d1522433604553ad37ed6084"
    sha256 sonoma:        "6e8998ee30a50e1f554a2b60ba07fa41b060ca5e0bbd2127141c7ab3dfe14c21"
    sha256 ventura:       "77dc1ed0d15dec8a1e439b0d90e536e341b44ff30a0cdce795040d1dbf176537"
    sha256 arm64_linux:   "cf6f82c290c7b56fb518c3267cef7f49a838f41196536bc4001190ad0152bfe2"
    sha256 x86_64_linux:  "0b59eccfaf5d2d701369a0feebbfeed127dbdf4cbf20acc31a71e22400a1a692"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "gettext"
  depends_on "glib"
  depends_on "json-glib"
  depends_on "libarchive"
  depends_on "libsoup"

  uses_from_macos "pod2man" => :build
  uses_from_macos "libxml2"

  def install
    system "meson", "setup", "build", *std_meson_args
    system "meson", "install", "-C", "build"
  end

  def post_install
    share.install_symlink HOMEBREW_PREFIX/"share/osinfo"
  end

  test do
    assert_equal "#{share}/osinfo", shell_output("#{bin}/osinfo-db-path --system").strip
  end
end
