class Ctl < Formula
  desc "Programming language for digital color management"
  homepage "https://github.com/ampas/CTL"
  license "AMPAS"
  revision 12
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
    sha256 cellar: :any,                 arm64_sonoma:   "a0168820a05b59e486be9e08500d23a1c6db05004c13b359c66273a42c94460d"
    sha256 cellar: :any,                 arm64_ventura:  "f8c3cbbb2404f37e00b825c3c72fd7a22757e3435e8e799402ce19d33740e316"
    sha256 cellar: :any,                 arm64_monterey: "4876e92dc02bc69c6c0c6aa6fe0cafa3dc06718a0a388f3977aa2ba7b45332b6"
    sha256 cellar: :any,                 arm64_big_sur:  "9be1c965bb3145b08728f102b33c519c83a6e7143625e562fb0b8fc9ca8355da"
    sha256 cellar: :any,                 sonoma:         "01b15b89bdbe253423b119b4f2dc955ce4d482b06d98450d63b353b3e50909b9"
    sha256 cellar: :any,                 ventura:        "f2e2507f4a8e553222b1e3a75db65c42af9bf27d8d71a60951ac0b777944897c"
    sha256 cellar: :any,                 monterey:       "d5b65911c6ac1e2c2d8966aa334d68ad23486edb76044657a2faa57c517002f7"
    sha256 cellar: :any,                 big_sur:        "b35ded51c3ee67c1ae4e9abad1ce085f8610fcc9a2e3b87212452ea292aafd31"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0211b234a9eeb9e5d316085c72bed2c98da00d913cd21b72ff2d02ed828190a9"
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
