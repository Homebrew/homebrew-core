class Libvidstab < Formula
  desc "Transcode video stabilization plugin"
  homepage "http://public.hronopik.de/vid.stab/"
  url "https://github.com/georgmartius/vid.stab/archive/v1.1.1.tar.gz"
  sha256 "9001b6df73933555e56deac19a0f225aae152abbc0e97dc70034814a1943f3d4"
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

  def install
    system "cmake", ".", "-DUSE_OMP=OFF", *std_cmake_args
    system "make", "install"
  end
end
