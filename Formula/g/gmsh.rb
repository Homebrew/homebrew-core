class Gmsh < Formula
  desc "3D finite element grid generator with CAD engine"
  homepage "https://gmsh.info/"
  url "https://gmsh.info/src/gmsh-4.15.0-source.tgz"
  sha256 "abb2632715bd7d0130ded7144fd6263635cd7dea883b8df61ba4da58ce6a1dfe"
  license "GPL-2.0-or-later"
  head "https://gitlab.onelab.info/gmsh/gmsh.git", branch: "master"

  livecheck do
    url :homepage
    regex(/href=.*?gmsh[._-]v?(\d+(?:\.\d+)+)[._-]source\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "8eb04e36c3e44e8ec280b2e1350be62739d51d49dabb65af74ccae48bb624d05"
    sha256 cellar: :any,                 arm64_sequoia: "07b486a223634ff27f6e1c8b5a1e38de0f0a5b5b6e535f4cbdb9b3079501c940"
    sha256 cellar: :any,                 arm64_sonoma:  "bec50ecb00386ad83d5b9a281e908fd157808432d8c578e190a2fea05c6252ca"
    sha256 cellar: :any,                 sonoma:        "c605fa873208382553ebdff480e0c42cc903e1bf7c0317205b9aae924547c0d4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "352639817aa70df6abffe79e1b60fbb571a1c9241fd7455ef398fcf1150e9859"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "53ce511f367d4f8650bdbb7070088952ff3e5e6f9424a7a7502e8ac95d485041"
  end

  depends_on "cmake" => :build
  depends_on "eigen" => :build
  depends_on "cairo"
  depends_on "fltk"
  depends_on "gmp"
  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "metis"
  depends_on "opencascade"

  uses_from_macos "zlib"

  on_macos do
    depends_on "freetype"
    depends_on "libomp"
  end

  on_linux do
    depends_on "mesa"
    depends_on "mesa-glu"
  end

  def install
    # Remove some bundled libraries to make sure brew formula is used
    rm_r(%w[
      contrib/eigen
      contrib/metis
    ])

    # Fix compile with newer Clang
    ENV.append_to_cflags "-Wno-implicit-function-declaration" if DevelopmentTools.clang_build_version >= 1403

    ENV["CASROOT"] = Formula["opencascade"].opt_prefix

    args = %w[
      -DENABLE_OS_SPECIFIC_INSTALL=OFF
      -DENABLE_BUILD_LIB=ON
      -DENABLE_BUILD_SHARED=ON
      -DENABLE_PETSC=OFF
      -DENABLE_SLEPC=OFF
      -DENABLE_OCC=ON
      -DENABLE_SYSTEM_CONTRIB=ON
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    # Move onelab.py into libexec instead of bin
    libexec.install bin/"onelab.py"
  end

  test do
    system bin/"gmsh", share/"doc/gmsh/examples/simple_geo/tower.geo", "-parse_and_exit"
  end
end
