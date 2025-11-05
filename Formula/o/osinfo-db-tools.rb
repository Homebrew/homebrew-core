class OsinfoDbTools < Formula
  desc "Tools for managing the libosinfo database files"
  homepage "https://libosinfo.org/"
  url "https://releases.pagure.org/libosinfo/osinfo-db-tools-1.12.0.tar.xz"
  sha256 "f3315f675d18770f25dea8ed04b20b8fc80efb00f60c37ee5e815f9c3776e7f3"
  license "GPL-2.0-or-later"
  revision 1

  livecheck do
    url "https://releases.pagure.org/libosinfo/?C=M&O=D"
    regex(/href=.*?osinfo-db-tools[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "b7fc390f20829e512e67af9a8f9a3b86855466c9d0e21eee106a0da42882b48c"
    sha256 arm64_sequoia: "4ded91dcb5ceb1686f85986abe0250d2af57854ecc98c29b9b4ab578e3979843"
    sha256 arm64_sonoma:  "a5829eb5c02044bbce9cbca10375cb9b0e7965a1a30c3ff072980e58c8dab76e"
    sha256 sonoma:        "ae990850409e0acb30784517f24f8d528607d9eb1462af765e05402b69997a1d"
    sha256 arm64_linux:   "26f1b31b01c82cdd183e3bba13791b37f2c2a4f1ee008ca988d22ec2c5bca928"
    sha256 x86_64_linux:  "107cbd58ea53e8c4bf198c838e0bb995bf896604c86f617c8dd3c8118a8101e4"
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
