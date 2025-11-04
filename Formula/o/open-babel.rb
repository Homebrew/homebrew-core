class OpenBabel < Formula
  desc "Chemical toolbox"
  homepage "https://github.com/openbabel/openbabel"
  license "GPL-2.0-only"
  revision 4
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
    sha256                               arm64_tahoe:   "c47e9e8ea40a2696cec7bd243305ae343b0155fb83ea762de2fd19206d1d0fdd"
    sha256                               arm64_sequoia: "b27a40c13f6483684ad331885588426d47769ae3e908eddfa85fc9b9fcb5d534"
    sha256                               arm64_sonoma:  "aea63f9ac32d735934c888291feeaed2e0df311d9d9ca245c2a3badae11785bf"
    sha256                               sonoma:        "17283bbbb30e3510464a2317b3de1103b5d7a40a362317cc5ec073ece0991a97"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "17fdce92285bb7c5701d4c10c24fff72e53a790537a3951ef78776c9a9e85b66"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d46e406f2ac959683c827270395e4dea9f2601f00cd7c657e549cdfcd01844b2"
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
  uses_from_macos "zlib"

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
