class Lensfun < Formula
  desc "Remove defects from digital images"
  homepage "https://lensfun.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/lensfun/0.3.2/lensfun-0.3.2.tar.gz"
  sha256 "ae8bcad46614ca47f5bda65b00af4a257a9564a61725df9c74cb260da544d331"
  revision 2
  head "https://git.code.sf.net/p/lensfun/code.git"

  bottle do
    sha256 "bf1ac72d74be58ba4d9b82cfca93cd5710e971a6c9dda783548583304b942efc" => :high_sierra
    sha256 "a67b367f01011cb03419b59577688290ab213c4cf35dcd4bafe353c62188edac" => :sierra
    sha256 "9056fb41bfed7c149fc65d795aa65eb0e67fb8e6ff3d542bcd6a7770c276c911" => :el_capitan
  end

  depends_on "python3"
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
