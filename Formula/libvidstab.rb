class Libvidstab < Formula
  desc "Transcode video stabilization plugin"
  homepage "http://public.hronopik.de/vid.stab/"
  url "https://github.com/georgmartius/vid.stab/archive/v1.1.0.tar.gz"
  sha256 "14d2a053e56edad4f397be0cb3ef8eb1ec3150404ce99a426c4eb641861dc0bb"
  license "GPL-2.0-or-later"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "e039ff1cf26ac9c1394519f31ff22894a803abe3393ecdbfd422fe8e092b6986"
    sha256 cellar: :any,                 arm64_monterey: "ece699a3cc725790bad5d1153f0203e06bfd64427f2b4915e4f4778a75d59635"
    sha256 cellar: :any,                 arm64_big_sur:  "b98be46d2375a1e6b30947b31c981009785a7c0e97c31ca0c64a52228b0d1576"
    sha256 cellar: :any,                 ventura:        "1572202724878ea4ebe12390dfe1b4919b14572a6ac4c15ba533413c07c3823b"
    sha256 cellar: :any,                 monterey:       "8ca80c30e8cbd76cf6aa593e39da3f0579ce60edbbb5bd4039b34b3cc00f493c"
    sha256 cellar: :any,                 big_sur:        "b4c67e80b92e95aa19520b0b130a60cc3949db7899d9d02520d32d9fc62ec837"
    sha256 cellar: :any,                 catalina:       "df23e5e7933b6535f34c429ee8286e4d9dec6d0a2349cf3256f44ec687e7968f"
    sha256 cellar: :any,                 mojave:         "783224577a1cc7a57de76eac74b00aac69e7fe15c920d26454e58a369854974f"
    sha256 cellar: :any,                 high_sierra:    "d3a80889cbeaa5a8af0abc5037c35afefb181e902b79f4f986a6b4c4e29d88a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1d3241dc43becd382cf761a8b79a253696f52d3ffeb4f762d82d9f9458152d57"
  end

  depends_on "cmake" => :build

  # A bug in the FindSSE CMake script means that, if a variable is defined
  # as an empty string without quoting, it doesn't get passed to a function
  # and CMake throws an error. This only occurs on ARM, because the
  # sysctl value being checked is always a non-empty string on Intel.
  # Upstream PR: https://github.com/georgmartius/vid.stab/pull/93
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/5bf1a0e0cfe666ee410305cece9c9c755641bfdf/libvidstab/fix_cmake_quoting.patch"
    sha256 "45c16a2b64ba67f7ca5335c2f602d8d5186c29b38188b3cc7aff5df60aecaf60"
  end

  def install
    system "cmake", ".", "-DUSE_OMP=OFF", *std_cmake_args
    system "make", "install"
  end
end
