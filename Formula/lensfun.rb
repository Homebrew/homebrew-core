class Lensfun < Formula
  desc "Remove defects from digital images"
  homepage "https://lensfun.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/lensfun/0.3.95/lensfun-0.3.95.tar.gz"
  sha256 "82c29c833c1604c48ca3ab8a35e86b7189b8effac1b1476095c0529afb702808"
  head "https://git.code.sf.net/p/lensfun/code.git"

  bottle do
    sha256 "974013385efd1386c3605de5352920b98810800ac37387d7f295dd70fcdad074" => :mojave
    sha256 "2a37991b1e54e6aab5dd75b6bee534010a1af7aa1378999713a96e174ae6f86a" => :high_sierra
    sha256 "b594d90fb2d169c3200bc4e06a033cf18ad87f89e2b43e1620952bea712ceb04" => :sierra
    sha256 "a057800dfa6b88a006cab751aa2708579b7d2f1816ac3c59c24fc4b12e4e4b76" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "glib"
  depends_on "libpng"
  depends_on "python"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    ENV["LC_ALL"] = "en_US.UTF-8"
    system bin/"lensfun-update-data"
  end
end
