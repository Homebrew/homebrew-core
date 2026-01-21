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
    sha256                               arm64_tahoe:   "d6f4008b2e5325223bc0d19908d67eea2c7530c1d44b56199bfb650822693622"
    sha256                               arm64_sequoia: "74eb232097ce4a70c19de17cd182920d2445bdcb76a4c50d46b6120ce2c51260"
    sha256                               arm64_sonoma:  "e8ab498a9d07c02f8ee4fdba64a17a960a1fbc87aa48f2a16417fd0204b41a28"
    sha256                               sonoma:        "6d3673642faf25364acf5efec9e8e7914e29fe151766a504acdf852342cd58a4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bd93d88d67a2413e837d21538547f7afaed7f8f5f560d6528ff6051539f94e7b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8981fddd1ab4e9354513f107f8b96673869295664c0391cf643646e92d221284"
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
