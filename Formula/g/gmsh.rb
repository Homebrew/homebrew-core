class Gmsh < Formula
  desc "3D finite element grid generator with CAD engine"
  homepage "https://gmsh.info/"
  url "https://gmsh.info/src/gmsh-4.14.1-source.tgz"
  sha256 "300cbb74b6fb88062aba70b1f5f31a8980177a4af415221a16ec8c0aa1d72afd"
  license "GPL-2.0-or-later"
  head "https://gitlab.onelab.info/gmsh/gmsh.git", branch: "master"

  livecheck do
    url :homepage
    regex(/href=.*?gmsh[._-]v?(\d+(?:\.\d+)+)[._-]source\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f8a7ea8fb7408e36c0d84051ae50d7c3bf31bca0f342a2a0256a6efc18c7a36e"
    sha256 cellar: :any,                 arm64_sequoia: "dea105b5a33efa70b43991b4a61bdde151175a3085a6d6610578e3d64bfa51a1"
    sha256 cellar: :any,                 arm64_sonoma:  "05e4f9fa688a67cac3a882b89dc6d9308ebdb9264ac7cafda812a41c6d4bde29"
    sha256 cellar: :any,                 arm64_ventura: "d451e58d3ea554f01686904ceb6140ecfb69822756b9fc1ac1d9ad235cdd9c6b"
    sha256 cellar: :any,                 sonoma:        "a87dae17f11a1c9866f2a5504398de74ded90db02617d42b028176dbe2dc0cf9"
    sha256 cellar: :any,                 ventura:       "28c66b1ca596b45fcc210b95decf2fb4e4d5eb68014a912d7359dd9e9d9683a9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "39514a606860446b6a79f5925aa2b7ae1e5ba6065739d475c5e04bb1aed0cbe7"
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
