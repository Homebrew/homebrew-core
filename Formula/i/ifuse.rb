class Ifuse < Formula
  desc "FUSE module for iOS devices"
  homepage "https://libimobiledevice.org/"
  url "https://github.com/libimobiledevice/ifuse/releases/download/1.2.1/ifuse-1.2.1.tar.bz2"
  sha256 "9d490470ba6553f8052b385bb5330462e46fbe82131ebe65be47a1cc1c70e857"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_linux:  "77cd5f5b3804240d52837a38f7e5f499430aa850c3a7bfe254c368bdc742a718"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "0987a44a88c77010ec95fa2f950d820fbd146cc38d49c03220f12c52b043c694"
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
