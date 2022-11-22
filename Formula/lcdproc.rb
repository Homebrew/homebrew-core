class Lcdproc < Formula
  desc "Display real-time system information on a LCD"
  homepage "http://www.lcdproc.org/"
  url "https://github.com/lcdproc/lcdproc/releases/download/v0.5.9/lcdproc-0.5.9.tar.gz"
  sha256 "d48a915496c96ff775b377d2222de3150ae5172bfb84a6ec9f9ceab962f97b83"
  license "GPL-2.0-or-later"
  revision 2

  bottle do
    sha256 ventura:      "ff2675dfa714a9de7e8d5a9f40c214cf5547c85c402337e7376a54631f43020a"
    sha256 monterey:     "90bb0544163a3966aac4de0dffaff4a9cc59cb05e08c314a28829fcf8df8e38b"
    sha256 big_sur:      "937564e19f5e45fd49b02e83577a4e217abf89ca3884958b3f9e80b2132fa8df"
    sha256 catalina:     "8899d5c5afebdf222f014f383e009071bda3f075a08e5f0d729a81f99c9c8086"
    sha256 x86_64_linux: "d869dec7aa2e03b2c6bc21a281ac56537d5a596e0a87442fc79fda035f000282"
  end

  depends_on "pkg-config" => :build
  depends_on arch: :x86_64
  depends_on "libftdi"
  depends_on "libusb"
  depends_on "libusb-compat" # Remove when all drivers migrated https://github.com/lcdproc/lcdproc/issues/13

  uses_from_macos "ncurses"

  def install
    system "./configure", *std_configure_args,
                          "--disable-silent-rules",
                          "--enable-drivers=all",
                          "--enable-libftdi=yes"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lcdproc -v 2>&1")
  end
end
