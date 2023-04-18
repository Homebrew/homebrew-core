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
    sha256 cellar: :any,                 arm64_ventura:  "6cd0756f34f96db87b0ee5f5d6151b3cff56d5bfbcc8dbcac9fdd7ec0ff0159e"
    sha256 cellar: :any,                 arm64_monterey: "696bda0b5754c559dd587e6ffa62c1f3040831e432c8996fb75d60b82b820021"
    sha256 cellar: :any,                 arm64_big_sur:  "b2d01be4863551ed9a706109fe891c1c8b6d7feeb6ace3c313274a4e5c457bdf"
    sha256 cellar: :any,                 ventura:        "09d07ef7f5ca64c724fae6f1b26f74599c03907009717350bae2ac3014bf9c13"
    sha256 cellar: :any,                 monterey:       "d640e7d666a56220ee5cfed1c1df0c22a5c16cbe00e1d0d5a6a2ee25c6326397"
    sha256 cellar: :any,                 big_sur:        "f40c8c8b9bf6a6f21df381ba11eadec141682098c2febb724819ffb69292149c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a2d0025b884c5bca8d338b8fc5610304b92f2ac6e2889e5758bfd556c1317b1d"
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
