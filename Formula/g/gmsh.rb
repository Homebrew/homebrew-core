class Gmsh < Formula
  desc "3D finite element grid generator with CAD engine"
  homepage "https://gmsh.info/"
  url "https://gmsh.info/src/gmsh-4.15.2-source.tgz"
  sha256 "be3f66f225d27ba9fa014f07e83169285da8a051b0e8ab7103d88066b39bdd3e"
  license "GPL-2.0-or-later"
  head "https://gitlab.onelab.info/gmsh/gmsh.git", branch: "master"

  livecheck do
    url :homepage
    regex(/href=.*?gmsh[._-]v?(\d+(?:\.\d+)+)[._-]source\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "021355a55df545d20640f58c27322ed74a61ba5965b38a86c3f9bfc1f64fa6b9"
    sha256 cellar: :any,                 arm64_sequoia: "ebddad85ddc6d3c372c6fdff29232c511d5445630501a5402a2bc1649562b945"
    sha256 cellar: :any,                 arm64_sonoma:  "506439d54d5c01c6b0a2b0eda6b0e7607273477bad06f4a41c9201bb60302a7d"
    sha256 cellar: :any,                 sonoma:        "740feb7cc42af02b825255611137a8425530f57fa793e37d7bc2623b9df742e9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c5c03ba09e23c9499b7d1d35648fc37ee517dc66f722170087ff0d24fe3f8355"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "73a7facb003343261dcaba2d3cbe5cd09448d61e730ed0087c6d44907dafc46f"
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

  on_macos do
    depends_on "freetype"
    depends_on "libomp"
  end

  on_linux do
    depends_on "mesa"
    depends_on "mesa-glu"
    depends_on "zlib-ng-compat"
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
