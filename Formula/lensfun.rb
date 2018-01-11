class Lensfun < Formula
  desc "Remove defects from digital images"
  homepage "https://lensfun.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/lensfun/0.3.2/lensfun-0.3.2.tar.gz"
  sha256 "ae8bcad46614ca47f5bda65b00af4a257a9564a61725df9c74cb260da544d331"
  revision 2
  head "https://git.code.sf.net/p/lensfun/code.git"

  bottle do
    sha256 "3a86b93b575783fdda2025b224d6d6a540760884f02d3491b1a4912fdb0aa823" => :high_sierra
    sha256 "3dcab083540a31a7aa28f78dfe1bcd18b29a03510b56ca4a9ffeae0963e2169b" => :sierra
    sha256 "2a6a0361c020ad9be4a827b5529d43bd80a814552f6d5943a54525e41f46c7c2" => :el_capitan
    sha256 "d61e3c9409a3145b5a0ea98af8453462c2f69d24b4753f429d1dcdff719e9e92" => :yosemite
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
