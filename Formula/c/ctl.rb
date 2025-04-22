class Ctl < Formula
  desc "Programming language for digital color management"
  homepage "https://github.com/ampas/CTL"
  license "AMPAS"
  revision 1
  head "https://github.com/ampas/CTL.git", branch: "master"

  # TODO: Remove `stable` block when patch is no longer needed.
  stable do
    url "https://github.com/ampas/CTL/archive/refs/tags/ctl-1.5.3.tar.gz"
    sha256 "0a9f5f3de8964ac5cca31597aca74bf915a3d8214e3276fdcb52c80ad25b0096"

    # Fix build failure due to ambiguous call to `clamp` with C++17
    # https://github.com/ampas/CTL/pull/164
    patch do
      url "https://github.com/ampas/CTL/commit/8108715a8cbbb0a0a81a00fb7239f228270047c1.patch?full_index=1"
      sha256 "4a48615dd434b80db01f23da56a2243d72d32f60a4a5c23655e5860a845eda6f"
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "9d2f566d3e81d03f0df20a22cafe1a0ffec738af1b3b8d8fb804c66bc57f1e42"
    sha256 cellar: :any,                 arm64_sonoma:  "6e5fa4335bc1b37de8c3fc53d05b4e6f6d1f98292d7f37101e58b4434b61e3e2"
    sha256 cellar: :any,                 arm64_ventura: "cca063bca6afc27b93575530d6ae3b4e27887646a4d84ec62bab91e112664f55"
    sha256 cellar: :any,                 sonoma:        "f765540b318344aae45d9cb0ab5f9399f82f08cc560b4bec4b427795e6232cf6"
    sha256 cellar: :any,                 ventura:       "db8b8b63a18cdd1070dd9ebde85a3a4d5e2d6f9e1e520d7d31e90375143f1f15"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e655c7062702656e1d9e4be0f0a6151cbc7056a40069f9ce40a0e8c0846d4761"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4ed74f26a409a8c6078dcdd8575a78a145991769103c40f2ee04cf65c2f59964"
  end

  depends_on "cmake" => :build
  depends_on "aces_container"
  depends_on "imath"
  depends_on "libtiff"
  depends_on "openexr"

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DBUILD_SHARED_LIBS=ON",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    "-DCTL_BUILD_TESTS=OFF",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_match "transforms an image", shell_output("#{bin}/ctlrender -help", 1)
  end
end
