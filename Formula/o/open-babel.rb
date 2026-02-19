class OpenBabel < Formula
  desc "Chemical toolbox"
  homepage "https://github.com/openbabel/openbabel"
  license "GPL-2.0-only"
  revision 5
  head "https://github.com/openbabel/openbabel.git", branch: "master"

  stable do
    url "https://github.com/openbabel/openbabel/releases/download/openbabel-3-1-1/openbabel-3.1.1-source.tar.bz2"
    sha256 "a6ec8381d59ea32a4b241c8b1fbd799acb52be94ab64cdbd72506fb4e2270e68"

    # Backport support for configuring PYTHON_INSTDIR to avoid Setuptools
    patch do
      url "https://github.com/openbabel/openbabel/commit/f7910915c904a18ac1bdc209b2dc9deeb92f7db3.patch?full_index=1"
      sha256 "f100bb9bffb82b318624933ddc0027eeee8546bf4d6deda5067ecbd1ebd138ea"
    end
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256                               arm64_tahoe:   "2c456fe61ba2215e23fa09d39cb689657c1ca8f73d46eac8e9216171e3464ac1"
    sha256                               arm64_sequoia: "e7d58eda61ed6ac0d01c9025485ffa6c8cd5ed22948dcc3111aabaf64f157637"
    sha256                               arm64_sonoma:  "f93aaad06396b9f3b960319baa8c6579a4e7b6ceb21f0f4c64f139b00f8a95e0"
    sha256                               sonoma:        "97be0b112e05a4f9ab90c96895d8893316edb68e05deffff11b9d0ccdb7e8a47"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "89bea578b4834dc7ec4e571d6d5902f997d1bc98dbc0ae2b47354eb714e514c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "af664d295e831c8bb50b88cf5457936d37843930d17685b7d2b7cddcf4e7a960"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "rapidjson" => :build
  depends_on "swig" => :build

  depends_on "cairo"
  depends_on "eigen"
  depends_on "inchi"
  depends_on "python@3.14"

  uses_from_macos "libxml2"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def python3
    "python3.14"
  end

  conflicts_with "surelog", because: "both install `roundtrip` binaries"

  def install
    # Fix to error: ‘clock’ was not declared in this scope on Linux
    inreplace "include/openbabel/obutil.h", "#include <math.h>", "#include <ctime>\n\\0"

    args = %W[
      -DINCHI_INCLUDE_DIR=#{Formula["inchi"].opt_include}/inchi
      -DOPENBABEL_USE_SYSTEM_INCHI=ON
      -DRUN_SWIG=ON
      -DPYTHON_BINDINGS=ON
      -DPYTHON_EXECUTABLE=#{which(python3)}
      -DPYTHON_INSTDIR=#{prefix/Language::Python.site_packages(python3)}
    ]

    # Workaround to build with CMake 4
    args << "-DCMAKE_POLICY_VERSION_MINIMUM=3.5"
    inreplace "CMakeLists.txt", "cmake_policy(SET CMP0042 OLD)",
                                "cmake_policy(SET CMP0042 NEW)"

    # Workaround to build with eigen 5.0.0
    # Issue ref: https://github.com/openbabel/openbabel/issues/2839
    args += %W[-DEIGEN3_FOUND=ON -DEIGEN3_INCLUDE_DIR=#{Formula["eigen"].opt_include}/eigen3]
    inreplace "CMakeLists.txt", "set (CMAKE_CXX_STANDARD 11)", "set (CMAKE_CXX_STANDARD 14)"
    rm "cmake/modules/FindEigen3.cmake"

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_match <<~EOS, shell_output("#{bin}/obabel -:'C1=CC=CC=C1Br' -omol")

        7  7  0  0  0  0  0  0  0  0999 V2000
          0.0000    0.0000    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0
          0.0000    0.0000    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0
          0.0000    0.0000    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0
          0.0000    0.0000    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0
          0.0000    0.0000    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0
          0.0000    0.0000    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0
          0.0000    0.0000    0.0000 Br  0  0  0  0  0  0  0  0  0  0  0  0
        1  6  1  0  0  0  0
        1  2  2  0  0  0  0
        2  3  1  0  0  0  0
        3  4  2  0  0  0  0
        4  5  1  0  0  0  0
        5  6  2  0  0  0  0
        6  7  1  0  0  0  0
      M  END
    EOS

    system python3, "-c", "from openbabel import openbabel"
  end
end
