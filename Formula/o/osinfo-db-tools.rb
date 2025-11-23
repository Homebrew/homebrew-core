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
    rebuild 1
    sha256 arm64_tahoe:   "5613764761db0551e4dd70012bf9088d11d03b38a3ab30af568d5b92cfac2b36"
    sha256 arm64_sequoia: "4db19ac55829b9c4c19e6e8f20c1c0e9078d3c8dd25bd6335be2a275e2c7c2c6"
    sha256 arm64_sonoma:  "02f32ab481a672e983fe9fdbff99bd4979ffbd9b178bad7f07a18bcb0c0fbd3e"
    sha256 sonoma:        "197d84a4fa2c29c46477f2140366dff49d33050d1dfbe270c37777df1a0aaf20"
    sha256 arm64_linux:   "298c576ca5746eb674c6c9bce5d51e6f1e4fcdcdd47367e50c74a6f7b4442e0f"
    sha256 x86_64_linux:  "5432275a5e7c855af96a4eee2c464566ed2b46c379ad81fe86feb1f9f940fd49"
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

  skip_clean "share/osinfo"

  def install
    system "meson", "setup", "build", *std_meson_args
    system "meson", "install", "-C", "build"
    share.install_symlink HOMEBREW_PREFIX/"share/osinfo"
  end

  test do
    assert_equal "#{share}/osinfo", shell_output("#{bin}/osinfo-db-path --system").strip
  end
end
