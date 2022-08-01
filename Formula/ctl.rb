class Ctl < Formula
  desc "Programming language for digital color management"
  homepage "https://github.com/ampas/CTL"
  # Check whether this can be switched to `openexr` and `imath` at version bump
  url "https://github.com/ampas/CTL/archive/ctl-1.5.2.tar.gz"
  sha256 "d7fac1439332c4d84abc3c285b365630acf20ea041033b154aa302befd25e0bd"
  license "AMPAS"
  revision 7

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "98141badc00f97bdb0ee0eb39907f17b5fefc66997eaf8afda40804946dac8de"
    sha256 cellar: :any,                 arm64_big_sur:  "c235c302216f52be88e6f0a5f9e7faef084a47c798ed0bccbb9614359d98dc91"
    sha256 cellar: :any,                 monterey:       "3dcbd25335f8fb6c3caf487683a31d26a065c80f72d8e64f2bb07f3816244894"
    sha256 cellar: :any,                 big_sur:        "bc7e4ae104c61190d92029ceb8ab28492b454319f9ba23a8e64952f2f4bff931"
    sha256 cellar: :any,                 catalina:       "e542c0ecc0914cee1d95ec473a38424229ba74a45299122f0f4cb6fa3a880066"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "32a5b3715f75d4916d2488ba2382ba5f9dbc8e3562dff192eb279eb9b7b44d1c"
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
