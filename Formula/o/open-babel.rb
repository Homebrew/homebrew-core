class OpenBabel < Formula
  desc "Chemical toolbox"
  homepage "https://github.com/openbabel/openbabel"
  license "GPL-2.0-only"
  revision 2
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

  bottle do
    rebuild 3
    sha256 arm64_sequoia: "238bdc90eeac4fb94c711c2b8ca8314341f4d0e825c33f42bd555ec9309103b8"
    sha256 arm64_sonoma:  "1de8660be91e1b7d3743c68aa9b16a0d77e02717817aa95d2a96e1e8d5f58381"
    sha256 arm64_ventura: "dbc696f70eb7d9edce1f77b3a97b4bbb991ea25c4049facf22dff653249035e3"
    sha256 sonoma:        "4c66243cacbc953bde3dabd83c001f3cba59d9baa1af0fe86971d40e72e6f982"
    sha256 ventura:       "c425540f55c1f4d0ff7bc8890cea80d7369452646c18f477a959db37b0315225"
    sha256 x86_64_linux:  "561dc0fb1c18ee4f91fdb0cbf9fcbbd1907a44a77e4610e13e41f3bca727b5a5"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "rapidjson" => :build
  depends_on "swig" => :build

  depends_on "cairo"
  depends_on "eigen"
  depends_on "inchi"
  depends_on "python@3.12"

  uses_from_macos "libxml2"
  uses_from_macos "zlib"

  def python3
    "python3.12"
  end

  conflicts_with "surelog", because: "both install `roundtrip` binaries"

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DINCHI_INCLUDE_DIR=#{Formula["inchi"].opt_include}/inchi",
                    "-DOPENBABEL_USE_SYSTEM_INCHI=ON",
                    "-DRUN_SWIG=ON",
                    "-DPYTHON_BINDINGS=ON",
                    "-DPYTHON_EXECUTABLE=#{which(python3)}",
                    "-DPYTHON_INSTDIR=#{prefix/Language::Python.site_packages(python3)}",
                    *std_cmake_args
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
