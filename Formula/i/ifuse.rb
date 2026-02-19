class Ifuse < Formula
  desc "FUSE module for iOS devices"
  homepage "https://libimobiledevice.org/"
  url "https://github.com/libimobiledevice/ifuse/archive/refs/tags/1.2.0.tar.gz"
  sha256 "29ab853037d781ef19f734936454c7f7806d1c46fbcca6e15ac179685ab37c9c"
  license "LGPL-2.1-or-later"
  head "https://github.com/libimobiledevice/ifuse.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_linux:  "22167141508080750debc73ef0718dee5bcf9fa06266e7620764ce5e4d2a7c75"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "61d48166f2afbac7409f38dc618df93dd97dee916fc6d0c32410d4c112bcf282"
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
    # This file can be generated only if `.git` directory is present
    # Create it manually
    (buildpath/".tarball-version").write version.to_s

    system "./autogen.sh", *std_configure_args
    system "make", "install"
  end

  test do
    # Actual test of functionality requires osxfuse, so test for expected failure instead
    assert_match "ERROR: No device found!", shell_output("#{bin}/ifuse --list-apps", 1)
  end
end
