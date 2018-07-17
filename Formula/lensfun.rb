class Lensfun < Formula
  desc "Remove defects from digital images"
  homepage "https://lensfun.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/lensfun/0.3.95/lensfun-0.3.95.tar.gz"
  sha256 "82c29c833c1604c48ca3ab8a35e86b7189b8effac1b1476095c0529afb702808"
  head "https://git.code.sf.net/p/lensfun/code.git"

  bottle do
    sha256 "2631e0144929796bd3d515c74a0daca37e34e1cea32fa4566fd9ea2c03b78307" => :high_sierra
    sha256 "9e5c6615b023a0e2eb2880c5a7a3b099cf2f6ddf06494f4b6d54a732e642b48a" => :sierra
    sha256 "0e31f53985babe7618f555c98968462f6570d1ed322e8dd194bfc53f7d73cb81" => :el_capitan
  end

  depends_on "python"
  depends_on "pkg-config" => :build
  depends_on "cmake" => :build
  depends_on "glib"
  depends_on "gettext"
  depends_on "libpng"
  depends_on "doxygen" => :optional

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    ENV["LC_ALL"] = "en_US.UTF-8"
    system bin/"lensfun-update-data"
  end
end
