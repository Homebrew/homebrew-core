class CmuPocketsphinx < Formula
  desc "Lightweight speech recognition engine for mobile devices"
  homepage "https://cmusphinx.github.io/"
  url "https://github.com/cmusphinx/pocketsphinx/archive/refs/tags/v5.0.4.tar.gz"
  sha256 "9acd63cfdc76bbc85b7b6c6610b7a9cf30c79d5b36a31de7dc2f969e962653d7"
  license "BSD-2-Clause"
  head "https://github.com/cmusphinx/pocketsphinx.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_tahoe:   "c1a4f7025051837a5d8fa4386b9a2b30f64c965eaab47ab2a88bb4d480837fbc"
    sha256 arm64_sequoia: "7b31ea299662e699efe85ccea3092117e8e2ed25233771078c469e7f4c82521d"
    sha256 arm64_sonoma:  "13fcebdc39149f153302f6c2859a8b96bdc49dd2e0c10dada760ee946bb2d07e"
    sha256 arm64_ventura: "152c0f76cb442ab833dcdcbd9f17398fc47b5dbbd650694c89be3b92acf53c9c"
    sha256 sonoma:        "2baa0d2ffe3d6d3608a51c20831cb299d4c85cf19cb048a5f04148e2abf9f163"
    sha256 ventura:       "9a9bfbfacda1094ff4bc6b6d213111e1ce9bcaec0ef0e8c5d17439988a30fa68"
    sha256 arm64_linux:   "9780ac9cbd3ab1a9defa7729ed9c647e9fd6f9a72195225a786615c6ecbf6692"
    sha256 x86_64_linux:  "5b035c6fbe339151707b82694ad2f9d793c2b6bb2f62bad2990d088bcbf2422b"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args,
                                              "-DBUILD_SHARED_LIBS=ON",
                                              "-DCMAKE_INSTALL_RPATH=#{rpath}"
    system "cmake", "--build", "build"
    system "cmake", "--build", "build", "--target", "install"
  end
end
