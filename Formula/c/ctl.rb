class Ctl < Formula
  desc "Programming language for digital color management"
  homepage "https://github.com/ampas/CTL"
  license "AMPAS"
  revision 11
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
    sha256 cellar: :any,                 arm64_ventura:  "cdc71889be6ec9f4f280f5fa5c8a72cb9c7ca9e6588229d35eeb4a1877c61859"
    sha256 cellar: :any,                 arm64_monterey: "11119356b12393c4a8f7448982b83de1d0ad6405745a09db528958879d9fa57e"
    sha256 cellar: :any,                 arm64_big_sur:  "4089483e5265167d537fffcfb68621d4927bf62f51e306a981c483d6b69525c0"
    sha256 cellar: :any,                 ventura:        "7fecce2608e7795527d15fbdef9571fe4947e46ce8db4d994d38536807823b97"
    sha256 cellar: :any,                 monterey:       "e072aff5a5dfefd958c13d3bf08e9c943fc8f08f66e88a70a69ce60100e036cd"
    sha256 cellar: :any,                 big_sur:        "62e5b288aafbf8ef6fcff899c747ba53344875895a90dcccea556cf78a3abd2c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "681f0c064d860bfadfde8a8781e677776098bf214d1f41300444e9ee613cbcda"
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
