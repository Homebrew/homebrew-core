class Libccd < Formula
  desc "Collision detection between two convex shapes"
  homepage "https://github.com/danfis/libccd"
  url "https://github.com/danfis/libccd/archive/refs/tags/v2.1.tar.gz"
  sha256 "542b6c47f522d581fbf39e51df32c7d1256ac0c626e7c2b41f1040d4b9d50d1e"
  license "BSD-3-Clause"
  revision 1

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "5706b5ddc123fae6306e45daf32a9485c8fa2186bb2966c5d4842c060db7f760"
    sha256 cellar: :any,                 arm64_sequoia:  "69d7221dceabfe62cded58442a541ed7b4e40dc91195ddc1032d9219d6d4eb80"
    sha256 cellar: :any,                 arm64_sonoma:   "0a6c12b8b5b369018a4186622359a2b9bc8ce40a4c0fe2452263e2d4ef03d92a"
    sha256 cellar: :any,                 arm64_ventura:  "9db2e87ee4c5b69faa9269a54f22046b5c4d18a72a65bc0dd4164c35a23edbe1"
    sha256 cellar: :any,                 arm64_monterey: "95bbd2e402b8388a6b348fd755b6997ae765568357115013996efe9e596f982f"
    sha256 cellar: :any,                 arm64_big_sur:  "69d8c269bc6c5f60d141eaebe6bdff9cf333f789c4d3b72cd69b1e61edff3ea3"
    sha256 cellar: :any,                 sonoma:         "5123a16281a3d428e8ad649027bc6749139b484c1dc6257a9a8e2883a29ee859"
    sha256 cellar: :any,                 ventura:        "6c11cd8ecc1c3434badf237f5b2169731ce62698f07e3dea3fe2420c57186deb"
    sha256 cellar: :any,                 monterey:       "b07fdb5107c0a1e3b912f441d338729ff2d58a50b65f3d6f5d013e26fa1c9dc2"
    sha256 cellar: :any,                 big_sur:        "8257a7f8ab8f5eca8fced2e881b96a68202c08ce94a4aa169d1d80149b61eb0f"
    sha256 cellar: :any,                 catalina:       "caa0aba8d2ba740998b54c73d3ab038747ac984e4d27797b9f768195a487dc4e"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "01cc57b08faa7b8a20a6d84a3cbe0908b7c5490d2223eea64b0f57df8fc8aa8d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6bee053612267522f0eb8c55c24a68dddb787126f46771fc8459d4d3460aa077"
  end

  depends_on "cmake" => :build

  def install
    args = %w[
      -DENABLE_DOUBLE_PRECISION=ON
    ]
    # Workaround to build with CMake 4
    args << "-DCMAKE_POLICY_VERSION_MINIMUM=3.5"
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <assert.h>
      #include <ccd/config.h>
      #include <ccd/vec3.h>
      int main() {
      #ifndef CCD_DOUBLE
        assert(false);
      #endif
        ccdVec3PointSegmentDist2(
          ccd_vec3_origin, ccd_vec3_origin,
          ccd_vec3_origin, NULL);
        return 0;
      }
    C
    system ENV.cc, "-o", "test", "test.c", "-L#{lib}", "-lccd"
    system "./test"
  end
end
