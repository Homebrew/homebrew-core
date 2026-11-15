class OsinfoDbTools < Formula
  desc "Tools for managing the libosinfo database files"
  homepage "https://libosinfo.org/"
  url "https://gitlab.com/libosinfo/osinfo-db-tools/-/releases/v1.12.0/downloads/osinfo-db-tools-1.12.0.tar.xz"
  sha256 "f3315f675d18770f25dea8ed04b20b8fc80efb00f60c37ee5e815f9c3776e7f3"
  license "GPL-2.0-or-later"
  revision 1
  compatibility_version 1
  head "https://gitlab.com/libosinfo/osinfo-db-tools.git", branch: "main"

  bottle do
    rebuild 2
    sha256 arm64_golden_gate: "b0fac1abd622023d38a5c7cb0f062ae69fecc7a6eaf023249801bf4b7f0eafc6"
    sha256 arm64_tahoe:       "520fac157eeaa4b2700c01b2912f7cda755e936feacd628f09ce3b459665629d"
    sha256 arm64_sequoia:     "f5951365a1e4ccc19c8e462cd054dcf818bbd6b8a60f4f283e86387c6bc398bb"
    sha256 arm64_linux:       "9224cf3cd6c335d04f66d9d6a818ed2ecdf5b8e25707bcf8e4baa9876d1edc2a"
    sha256 x86_64_linux:      "ffe0645893cb43a88f0071f8cd4258f3fc64dafd2d8276cebd039546b623514c"
  end

  depends_on "gettext" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "glib"
  depends_on "json-glib"
  depends_on "libarchive"
  depends_on "libsoup"

  uses_from_macos "pod2man" => :build
  uses_from_macos "libxml2"

  on_macos do
    depends_on "gettext"
  end

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
