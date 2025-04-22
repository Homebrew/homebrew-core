class Gmsh < Formula
  desc "3D finite element grid generator with CAD engine"
  homepage "https://gmsh.info/"
  license "GPL-2.0-or-later"
  revision 3
  head "https://gitlab.onelab.info/gmsh/gmsh.git", branch: "master"

  stable do
    url "https://gmsh.info/src/gmsh-4.13.1-source.tgz"
    sha256 "77972145f431726026d50596a6a44fb3c1c95c21255218d66955806b86edbe8d"

    # Backport fix for newer fltk
    patch do
      url "https://gitlab.onelab.info/gmsh/gmsh/-/commit/3b3f0f7e16430939b345889a9e31b50104d5baf3.diff"
      sha256 "194b2822123c36e18260db5c14b98127c2a6721de2f5272bd0bd9456580465c3"
    end
  end

  livecheck do
    url :homepage
    regex(/href=.*?gmsh[._-]v?(\d+(?:\.\d+)+)[._-]source\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "cf5c8f43758e346366f53bf60865e5d6f03298eba5e26f251a88e42af4716552"
    sha256 cellar: :any,                 arm64_sonoma:  "8ba053b9490f1568a75c46dd7b2ec7d806a4dfa82c4a8461c98a6814ca101adb"
    sha256 cellar: :any,                 arm64_ventura: "e659b97a98f1047d2b83b2265d3a05a1cc2ec8b819869979ca713fe0b12aaf57"
    sha256 cellar: :any,                 sonoma:        "7c06d9608699dd84a080a9dc8e265260c3a666b834b9d76d7214e8075971bec3"
    sha256 cellar: :any,                 ventura:       "e527cf0fa674c848605096e23d24c687455e2fa56b427d7d6e90bf6d9c345a87"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "053b6c6984b71f7bb1c5763dd75ee6c3c1adda0db4cfc080efcffe46443615f1"
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
