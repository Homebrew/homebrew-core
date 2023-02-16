class CmuPocketsphinx < Formula
  desc "Lightweight speech recognition engine for mobile devices"
  homepage "https://cmusphinx.github.io/"
  url "https://github.com/cmusphinx/pocketsphinx/archive/v5.0.0.tar.gz"
  sha256 "78ffe5b60b6981b08667435dd26c5a179b612b8ca372bd9c23c896a8b2239a20"
  license "BSD-2-Clause"
  head "https://github.com/cmusphinx/pocketsphinx.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_ventura:  "cb3db8f8860e169f7bcdb427935fccdf2b9cddb1c3c1891d296a098664f4ba42"
    sha256 arm64_monterey: "314f80412a27862cdb5b857b3ae8273e28e29f81dcb4279d60228b149df9b97f"
    sha256 arm64_big_sur:  "4c3fc6b03df2530653a4ff38b270e9a37dd968748b38a011cae6500ab38d8084"
    sha256 ventura:        "b3ce7baee259f699334d2a00e412c99ee1ee582f104875bc747e372933b19625"
    sha256 monterey:       "263434383a2856a30d3119a4683a7c61a52521f08b8ee7bd08f02d8b1efa2de7"
    sha256 big_sur:        "25ce90366420de438c34e8f037f1da3c7ded680375fcc69127cdec7695f84fed"
    sha256 catalina:       "f2fc23a67634f26befdd128d21e886d7b3789484a14d498a40949e0e100d8afa"
    sha256 mojave:         "cc655d82bfce35b2976e4dd0867fceb02b233363e7e101c62b09e60e2be9f8bb"
    sha256 high_sierra:    "628d162751962337c769090867c3f9921d10b09f704f8f208b63abbefef205eb"
    sha256 sierra:         "12abc8b527906e7ed0d2f6f0a6b6cb5c00f548fe94fcce995bdc80f43b4cf17b"
    sha256 el_capitan:     "2f1f4738dbcf7641a530b82c4dc6447ecadb5f9b60cd2484c33c379efb5c46e5"
    sha256 x86_64_linux:   "3807f33dd6becb2a82ff3ba4062f6604a4001a2650d98526815b17b799627a17"
  end

  depends_on "cmake" => :build

  # Fix header installation. Can be removed in next release after 5.0.0.
  patch do
    url "https://github.com/cmusphinx/pocketsphinx/commit/74a5ec86468a481cae2a6167a0921455354232d3.patch?full_index=1"
    sha256 "ef9ad6edbba721cc3e4fe0cf9ba0dd14ed18b9f4cb4be079e021f0e28221160a"
  end

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, "-DBUILD_SHARED_LIBS=ON"
    system "cmake", "--build", "build"
    system "cmake", "--build", "build", "--target", "install"
  end
end
