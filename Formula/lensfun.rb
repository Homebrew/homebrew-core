class Lensfun < Formula
  desc "Remove defects from digital images"
  homepage "https://lensfun.sourceforge.io/"
  url "https://dl.bintray.com/homebrew/mirror/lensfun-0.3.2.tar.gz"
  mirror "https://downloads.sourceforge.net/project/lensfun/0.3.2/lensfun-0.3.2.tar.gz"
  sha256 "ae8bcad46614ca47f5bda65b00af4a257a9564a61725df9c74cb260da544d331"
  revision 3
  head "https://git.code.sf.net/p/lensfun/code.git"

  bottle do
    sha256 "205e318f6d296696af3c31b088315efe148e543a761715ed74790c5ac9b4acfd" => :high_sierra
    sha256 "6bad87c166dfc09702dafb5509c18436423824f9f3ccb45b2d79ae458c0fcc98" => :sierra
    sha256 "66272da3d4b5775c1f2cd468ae645db9d804d935c6533e842b4c0c702c44d33a" => :el_capitan
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
