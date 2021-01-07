class Ifuse < Formula
  desc "FUSE module for iOS devices"
  homepage "https://www.libimobiledevice.org/"
  url "https://github.com/libimobiledevice/ifuse/archive/1.1.4.tar.gz"
  sha256 "2a00769e8f1d8bad50898b9d00baf12c8ae1cda2d19ff49eaa9bf580e5dbe78c"
  license "LGPL-2.1"
  head "https://cgit.sukimashita.com/ifuse.git"

  bottle do
    cellar :any
    sha256 "cdce9fc5dbaf44641743b4a77434d340ae11cb8ed98f17b1a86a5653d2b6e1a2" => :catalina
    sha256 "e14e4f8e0f73324dc662b47f091261f682eddc73961e3d71a07bfeb62826a1f8" => :mojave
    sha256 "ff5577f28749cf18671eecd953e96f0c52a06dccf827dcf08e2d64f894dfdd5e" => :high_sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "libimobiledevice"
  depends_on "libplist"

  on_macos do
    deprecate! date: "2020-11-10", because: "requires FUSE"
    depends_on :osxfuse
  end

  on_linux do
    depends_on "libfuse"
  end

  def install
    system "./autogen.sh"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    # Actual test of functionality requires osxfuse, so test for expected failure instead
    assert_match "ERROR: No device found!", shell_output("#{bin}/ifuse --list-apps", 1)
  end
end
