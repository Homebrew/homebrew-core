class Ctl < Formula
  desc "Programming language for digital color management"
  homepage "https://github.com/ampas/CTL"
  license "AMPAS"
  revision 8
  head "https://github.com/ampas/CTL.git", branch: "master"

  stable do
    url "https://github.com/ampas/CTL/archive/ctl-1.5.2.tar.gz"
    sha256 "d7fac1439332c4d84abc3c285b365630acf20ea041033b154aa302befd25e0bd"

    # Backport support for OpenEXR/Imath 3. Remove in the next release.
    # Due to large number of changes from last stable release to OpenEXR 3 commit
    # https://github.com/ampas/CTL/commit/3fc4ae7a8af35d380654e573d895216fd5ba407e,
    # we apply a patch generated from GitHub compare range.
    patch do
      url "https://github.com/ampas/CTL/compare/ctl-1.5.2..3fc4ae7a8af35d380654e573d895216fd5ba407e.patch?full_index=1"
      sha256 "701df07c80ad10341d8e70da09ce4a624ae3cccbe86e72bf07e6e6187bca96cc"
    end

    # Fix installation error: file cannot create directory: /CTL.
    # Remove in the next release.
    patch do
      url "https://github.com/ampas/CTL/commit/f2474a09f647426302472009649edb4c3daac471.patch?full_index=1"
      sha256 "9adb22c5558bf661afea173695bad0a23a19af12981ba31c9fc0c6f9129fe6f1"
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "4e53012495e07442d42c90ef1e566a07b114768054980bc10cd74511cb4e1a85"
    sha256 cellar: :any,                 arm64_monterey: "98141badc00f97bdb0ee0eb39907f17b5fefc66997eaf8afda40804946dac8de"
    sha256 cellar: :any,                 arm64_big_sur:  "c235c302216f52be88e6f0a5f9e7faef084a47c798ed0bccbb9614359d98dc91"
    sha256 cellar: :any,                 ventura:        "217d0dd2989005a534475d9bc5a24dad3902deaceb5b386d4c70f4830922cf6d"
    sha256 cellar: :any,                 monterey:       "3dcbd25335f8fb6c3caf487683a31d26a065c80f72d8e64f2bb07f3816244894"
    sha256 cellar: :any,                 big_sur:        "bc7e4ae104c61190d92029ceb8ab28492b454319f9ba23a8e64952f2f4bff931"
    sha256 cellar: :any,                 catalina:       "e542c0ecc0914cee1d95ec473a38424229ba74a45299122f0f4cb6fa3a880066"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "32a5b3715f75d4916d2488ba2382ba5f9dbc8e3562dff192eb279eb9b7b44d1c"
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
