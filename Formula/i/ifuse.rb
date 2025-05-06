class Ifuse < Formula
  desc "FUSE module for iOS devices"
  homepage "https://libimobiledevice.org/"
  license "LGPL-2.1-or-later"
  revision 2
  head "https://github.com/libimobiledevice/ifuse.git", branch: "master"

  stable do
    url "https://github.com/libimobiledevice/ifuse/archive/refs/tags/1.1.4.tar.gz"
    sha256 "2a00769e8f1d8bad50898b9d00baf12c8ae1cda2d19ff49eaa9bf580e5dbe78c"

    # Backport support for libfuse 3
    patch do
      url "https://github.com/libimobiledevice/ifuse/commit/36956a5179e224f57ebb9d0f01314c09c8bf0f97.patch?full_index=1"
      sha256 "47c87159f085977bc728f586c975b343f67bdf221b164bfef10a572546e80df3"
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_linux:  "734a650c8068975a04496c7efc513167c327b7202a112698745cea919ad75a6d"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "1c1e2348ff0c16c8d70685fb9112a77739aec3317e21079527dcb2abb0f99e8e"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build
  depends_on "glib"
  depends_on "libfuse"
  depends_on "libimobiledevice"
  depends_on "libplist"
  depends_on :linux # on macOS, requires closed-source macFUSE

  def install
    system "./autogen.sh", *std_configure_args
    system "make", "install"
  end

  test do
    # Actual test of functionality requires osxfuse, so test for expected failure instead
    assert_match "ERROR: No device found!", shell_output("#{bin}/ifuse --list-apps", 1)
  end
end
