class Ctl < Formula
  desc "Programming language for digital color management"
  homepage "https://github.com/ampas/CTL"
  # Check whether this can be switched to `openexr` and `imath` at version bump
  url "https://github.com/ampas/CTL/archive/ctl-1.5.2.tar.gz"
  sha256 "d7fac1439332c4d84abc3c285b365630acf20ea041033b154aa302befd25e0bd"
  license "AMPAS"
  revision 6

  bottle do
    sha256 arm64_big_sur: "e0279cf65e4c8dc7d574ef2e6e15e79e3d8632829cf7ba41535802d4d9d5d399"
    sha256 big_sur:       "3c08d14f9641ece8b5bff55783df5905f349974470452d4002c171d794265f65"
    sha256 catalina:      "e44cbdbb013b350d22ff4cafeeb2a8e93dd164dc36bb6e181fb5cf086a8345c1"
    sha256 mojave:        "6c88c03a0826a11e7267bf056e15362d4824cea2291b16af6db172d21f3654ce"
    sha256 high_sierra:   "61b7606c62fb60aa86d887084e1cb0aa194ff5c64cb9726208ee364f870d7b43"
  end

  depends_on "cmake" => :build
  depends_on "aces_container"
  depends_on "ilmbase"
  depends_on "libtiff"
  depends_on "openexr@2"

  # from https://github.com/ampas/CTL/pull/73
  patch do
    url "https://github.com/ampas/CTL/commit/bda2165b97e512a39ee67cf36fe95e1d897e823b.patch?full_index=1"
    sha256 "09145020a79b180bb8bb8e18129194b064d4c8a949940fb97be4945b99b06d7f"
  end

  # from https://github.com/ampas/CTL/pull/74
  patch do
    url "https://github.com/ampas/CTL/commit/0646adf9dcf966db3c6ec9432901c08387c1a1eb.patch?full_index=1"
    sha256 "5ec79eed7499612855d09d7bb18a66a660b6be9785fdfcc880d946f95fb7a44c"
  end

  def install
    ENV.cxx11
    ENV.delete "CTL_MODULE_PATH"

    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    assert_match "transforms an image", shell_output("#{bin}/ctlrender -help", 1)
  end
end
