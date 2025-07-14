class Gmsh < Formula
  desc "3D finite element grid generator with CAD engine"
  homepage "https://gmsh.info/"
  url "https://gmsh.info/src/gmsh-4.14.0-source.tgz"
  sha256 "db4d7da2062e9a4356a820832138ab99f97af6388bfeb21599a2eadfb0b76a28"
  license "GPL-2.0-or-later"
  head "https://gitlab.onelab.info/gmsh/gmsh.git", branch: "master"

  livecheck do
    url :homepage
    regex(/href=.*?gmsh[._-]v?(\d+(?:\.\d+)+)[._-]source\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "8c50799466377882e5045b15f4c23a8a4c1040dfbe955489788a6a2b31a8779e"
    sha256 cellar: :any,                 arm64_sonoma:  "32e4da3c38f226be85aa36455b2d92e306c32260098c18c2bb7e0d1b87bb67f4"
    sha256 cellar: :any,                 arm64_ventura: "1fc4a3ef69f860ac4a91bd1051cc36ec129a969d6f1329c4c91c68e9464c453f"
    sha256 cellar: :any,                 sonoma:        "96ca92471114ec67e694440cc3a8be930de5bdabf52c69c596f29e28e11de7e7"
    sha256 cellar: :any,                 ventura:       "0f618c7b6204e38f549ced91f1dca50eb1d77dd214e8bea4f59bac29c28c8dce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f4d2413693690bbe55855c96c8c2e05c7e66424f8c5b7bb3fc77dfda659be007"
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
