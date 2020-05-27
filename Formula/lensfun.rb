class Lensfun < Formula
  include Language::Python::Shebang

  desc "Remove defects from digital images"
  homepage "https://lensfun.github.io/"
  url "https://downloads.sourceforge.net/project/lensfun/0.3.95/lensfun-0.3.95.tar.gz"
  sha256 "82c29c833c1604c48ca3ab8a35e86b7189b8effac1b1476095c0529afb702808"
  revision 2

  bottle do
    sha256 "66ab460c11f7476a85c31f9941d2b2f35a416d1f2db9a75b029ed038ff63cf0c" => :catalina
    sha256 "913b9cebd837443975420bf43b32076b6cd52ca3358599f5ea05229f08e4cc9e" => :mojave
    sha256 "6c9f55d9fcc97aeb95654086f739b0ddfc95febb76e9c68037a262a535b3f87e" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "glib"
  depends_on "libpng"
  depends_on "python@3.8"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"

    rewrite_shebang detected_python_shebang,
      bin/"lensfun-add-adapter", bin/"lensfun-convert-lcp", bin/"lensfun-update-data"
  end

  test do
    ENV["LC_ALL"] = "en_US.UTF-8"
    system bin/"lensfun-update-data"
  end
end
