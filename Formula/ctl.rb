class Ctl < Formula
  desc "Programming language for digital color management"
  homepage "https://github.com/ampas/CTL"
  license "AMPAS"
  revision 9
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
    sha256 cellar: :any,                 arm64_ventura:  "768159ee7fa6cf3997c3b671f48ad51e7ce991642c28f89d6c8af79393b97d7a"
    sha256 cellar: :any,                 arm64_monterey: "e1476e5c6e33dbbae9ff08f061fdadce75976b91fa380636c024eff784370ca4"
    sha256 cellar: :any,                 arm64_big_sur:  "722893ea7b81ba66f4c8cd2fb8b00f012327c598d00d0f0231deb9443276ab35"
    sha256 cellar: :any,                 ventura:        "784f5bf53366b9affe8986d94e973da22d6b6922e6d84f68d01febb5a45f2064"
    sha256 cellar: :any,                 monterey:       "e83fc22e7d97d41d51782b7eacec690c22dabea019759d43efb27fdca0ea8b7e"
    sha256 cellar: :any,                 big_sur:        "358b2c880804cce08fedd64bc741f55e0bee6dce2287a3f9e350d65f66ca431e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "396500334794365ca00c69d561bb1458aec5b6d695ad627fea79b815fa67b89d"
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
