class Libcuefile < Formula
  desc "Library to work with CUE files"
  homepage "https://www.musepack.net/"
  url "https://files.musepack.net/source/libcuefile_r475.tar.gz"
  version "r475"
  sha256 "b681ca6772b3f64010d24de57361faecf426ee6182f5969fcf29b3f649133fe7"
  license "GPL-2.0"

  livecheck do
    url "https://www.musepack.net/index.php?pg=src"
    regex(/href=.*?libcuefile[._-](r\d+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "9329d1062814c86b9e6f85060654e962c06b4de6359756f6cdea2842c4280dc5"
    sha256 cellar: :any,                 arm64_monterey: "5c3e4f0219de1b452bdb4e6684a6a71520d6fe2ba6634d6c2a740d062110a292"
    sha256 cellar: :any,                 arm64_big_sur:  "2d73e0ee1f734eb35034383fa5e0697ace0684f0a1586832613227a6769b07d6"
    sha256 cellar: :any,                 ventura:        "716c579255d43e25cc737a655a136a966cfed604e97497547d949e052b961db5"
    sha256 cellar: :any,                 monterey:       "06a8a88fee28e5288aa1219f8bc5eb1b6f0a3d153dcb250d453d008dd98cbeab"
    sha256 cellar: :any,                 big_sur:        "2d4ea14db508f6439073daa64338f884249c7479af688ec91e4a286a3c42591e"
    sha256 cellar: :any,                 catalina:       "3069cf9b0261d8cedee8979348227f5c77a5c6dcb8942f9fbea20b3e3f190374"
    sha256 cellar: :any,                 mojave:         "1e64fe68ce178b904ac44a7a2c017a030c6f0ff87fb18b7c943c8c766f23d186"
    sha256 cellar: :any,                 high_sierra:    "a0b9b31c26ac9dc2704e71834259c0f9d0a12dce4ad4bbcdaae64fea5004ceae"
    sha256 cellar: :any,                 sierra:         "66ec2d9281a5459326a1b2d220b9f68fa241a6b9f8370324377af6751d60b7fd"
    sha256 cellar: :any,                 el_capitan:     "fc48e0953e3df489f37ee30214bd50b07020955b02f957a90c699474f09ef974"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8a8324a43e9b1e4782de409dacf6f82de5fa7b955ff871d2d10e56b2dd1324bb"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
    include.install "include/cuetools/"
  end
end
