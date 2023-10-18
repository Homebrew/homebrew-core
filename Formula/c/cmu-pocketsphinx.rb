class CmuPocketsphinx < Formula
  desc "Lightweight speech recognition engine for mobile devices"
  homepage "https://cmusphinx.github.io/"
  url "https://github.com/cmusphinx/pocketsphinx/archive/v5.0.2.tar.gz"
  sha256 "c2c58aa702195c46c44575fb9ed5790e749ab647df648b4557cc963aeac638b2"
  license "BSD-2-Clause"
  head "https://github.com/cmusphinx/pocketsphinx.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_sonoma:   "cfccf5e5cfc9477179d796be0e96c3632e330f1d981ebf186e7619e7c788103e"
    sha256 arm64_ventura:  "61be1cc07ffdfa2cbc5550ab6eab19dd73517b6267537775dfa72465f52c3c86"
    sha256 arm64_monterey: "6e00d4526d387045f24bc8c6f51e900a9273878c06aeb48b197c84fac7cc200c"
    sha256 arm64_big_sur:  "ea8bf108ed849e4421a46ec31397e9764c7968f516fbf7c3a8f9d90b98734bbb"
    sha256 sonoma:         "9d724d962443a2d2a8b3fa6e457ef69b312d8bb14a1748b6c2cccdceb0c96463"
    sha256 ventura:        "39b2efe0096bd86dbd1013644bdc872fd7be1b3c334ea5d6336a341bdb8c2215"
    sha256 monterey:       "06beccfe7a273878a75ebfb05a0a2d7d5d4341819da32b9aed4f4c22b5a00743"
    sha256 big_sur:        "add199146488b1ee046bd176709c9d497ffe9cd17908dbf19f8c9978de6d0860"
    sha256 x86_64_linux:   "b5e792e67553715c9c0372f30b94d17519990ea970e0dd64acf471ee702cef73"
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
