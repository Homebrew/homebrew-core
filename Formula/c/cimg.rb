class Cimg < Formula
  desc "C++ toolkit for image processing"
  homepage "https://cimg.eu/"
  url "https://cimg.eu/files/CImg_4.0.8.zip"
  sha256 "ac19142becada361283b18b27f6eaf49b121e857224117d52c214d1650e53b92"
  license "CECILL-2.0"
  compatibility_version 1

  livecheck do
    url "https://cimg.eu/files/"
    regex(/href=.*?CImg[._-]v?(\d+(?:\.\d+)+)\.zip/i)
  end

  bottle do
    manifest_sha256 "9b5dedc4232c27aad65155b304164daeb2dc47b84965ce530701fddfff381406"
    sha256 cellar: :any_skip_relocation, all: "062e0ee6c28da0a74dcfc1e2407844ca62c17e6c6dd2c7f34c6b023af02541a4"
  end

  deny_network_access!

  def install
    include.install "CImg.h"
    prefix.install "Licence_CeCILL-C_V1-en.txt", "Licence_CeCILL_V2-en.txt"
    pkgshare.install "examples", "plugins"
  end

  test do
    ENV.append "CXX", "-std=c++17"
    cp_r pkgshare/"examples", testpath
    cp_r pkgshare/"plugins", testpath
    cp include/"CImg.h", testpath
    system "make", "-C", "examples", "image2ascii"
    system "examples/image2ascii"
  end
end
