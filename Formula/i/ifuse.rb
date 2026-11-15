class Ifuse < Formula
  desc "FUSE module for iOS devices"
  homepage "https://libimobiledevice.org/"
  url "https://github.com/libimobiledevice/ifuse/releases/download/1.2.1/ifuse-1.2.1.tar.bz2"
  sha256 "9d490470ba6553f8052b385bb5330462e46fbe82131ebe65be47a1cc1c70e857"
  license "LGPL-2.1-or-later"
  revision 1

  bottle do
    sha256 cellar: :any, arm64_linux:  "fde2c9ac23dd7fe27002f7627d1831aeba02522cac8380db35f4d964c853b1d0"
    sha256 cellar: :any, x86_64_linux: "ddf9ec56b61a314f94d8cc22570fc0ad1eb2f533f8f2658d0f85520c2bd6d47a"
  end

  head do
    url "https://github.com/libimobiledevice/ifuse.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkgconf" => :build
  depends_on "glib"
  depends_on "libfuse"
  depends_on "libimobiledevice"
  depends_on "libplist"
  depends_on :linux # on macOS, requires closed-source macFUSE

  deny_network_access!

  def install
    if build.head?
      # This file can be generated only if `.git` directory is present
      # Create it manually
      (buildpath/".tarball-version").write version.to_s

      system "./autogen.sh", *std_configure_args
    else
      system "./configure", *std_configure_args
    end
    system "make", "install"
  end

  test do
    # Actual test of functionality requires osxfuse, so test for expected failure instead
    assert_match "ERROR: No device found!", shell_output("#{bin}/ifuse --list-apps", 1)
  end
end
