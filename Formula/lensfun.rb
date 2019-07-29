class Lensfun < Formula
  desc "Remove defects from digital images"
  homepage "https://lensfun.github.io/"
  url "https://downloads.sourceforge.net/project/lensfun/0.3.95/lensfun-0.3.95.tar.gz"
  sha256 "82c29c833c1604c48ca3ab8a35e86b7189b8effac1b1476095c0529afb702808"
  revision 1

  bottle do
    sha256 "071b05645a8d0fc6e87a80ab75dfd3ec1047ce6ab8dd33e193ddc1117d3da36c" => :mojave
    sha256 "ee89d7a5565ec4c467319ea4264a11f29574c82ac74b2fb68528b3acf0931530" => :high_sierra
    sha256 "1e5895e7d6b2d2788c8839fc4a846ad3d48352892d06ae6115fff36e934032cb" => :sierra
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
