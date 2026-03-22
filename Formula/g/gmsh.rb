class Gmsh < Formula
  desc "3D finite element grid generator with CAD engine"
  homepage "https://gmsh.info/"
  url "https://gmsh.info/src/gmsh-4.15.1-source.tgz"
  sha256 "eba8e4064f6586c8ca880f1cfdf697f4d70f026f398a93b458f247f7e4364fed"
  license "GPL-2.0-or-later"
  head "https://gitlab.onelab.info/gmsh/gmsh.git", branch: "master"

  livecheck do
    url :homepage
    regex(/href=.*?gmsh[._-]v?(\d+(?:\.\d+)+)[._-]source\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "1cb373fde7e3f6f31454676fbabb9cb508720c7efb9267316fbfbe80faf54c1a"
    sha256 cellar: :any,                 arm64_sequoia: "78f00331e2c998f04ab0cd4282dbc15342703bd93a78c3223d2988e52a14478e"
    sha256 cellar: :any,                 arm64_sonoma:  "838cfe7f30bd56988375465bef943da45392a4215fe5f4eca16385336cc9fdfc"
    sha256 cellar: :any,                 sonoma:        "2eb1629e09d260b2a9176d62a169649dc778392f35cf7045f643d26232186573"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "86cbc296324aca959e4f5be71c292029f8dd05fcc96090dcaf69af41141ec33d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a27ddf2c2994932c0c879eb436ebf6e3036b10670ac3a7964ebb6ed3ce7966ef"
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
