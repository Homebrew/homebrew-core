class CmuPocketsphinx < Formula
  desc "Lightweight speech recognition engine for mobile devices"
  homepage "https://cmusphinx.github.io/"
  url "https://github.com/cmusphinx/pocketsphinx/archive/refs/tags/v5.0.3.tar.gz"
  sha256 "5d952cb1c22e0a51ed1fafc36871612df38f145df64fa017fdc8074532ec007f"
  license "BSD-2-Clause"
  head "https://github.com/cmusphinx/pocketsphinx.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_sequoia:  "4705e9a91c76593611120daadc21808f85440d50d643a28a42de9a59d5145413"
    sha256 arm64_sonoma:   "175df005d88baaa5ae5c3c87ebf49282d4d0cff420e8103c019f34b802fe39ba"
    sha256 arm64_ventura:  "37b04476bf3f07d04e2575edd14422e96c8b3916aebb119259be1fd5dedec89c"
    sha256 arm64_monterey: "fade0f22899ba83dcc7971201f9f7ca27a35ec41eaf96869d9afe39c29d7ca9b"
    sha256 sonoma:         "e7c843f82e2c03255f068fc38f8397e07998bcce5c922c4ace345f18b3ae027c"
    sha256 ventura:        "ac9ffe4593490b0fb39c806a569cd1c1a0152d3f50219f8a3cb8ea497eb4262d"
    sha256 monterey:       "e9ca7f35b9f6846f3606e320af20b32aabc663af8008f404b51506498519f6d1"
    sha256 x86_64_linux:   "8583092ea181a04dea1250e5f6613e197469c6b3a5be3ad730ba3600a56c0130"
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
